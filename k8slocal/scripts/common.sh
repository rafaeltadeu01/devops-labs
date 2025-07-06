#!/bin/bash
set -e

echo "[Common] Instalando dependências..."

# Atualiza pacotes
apt-get update
apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release gnupg2 software-properties-common

# Containerd
echo "[Common] Instalando containerd..."
apt-get install -y containerd

# Cria configuração padrão do containerd
mkdir -p /etc/containerd
containerd config default | tee /etc/containerd/config.toml

# Usa systemd como cgroupDriver (recomendado pelo kubeadm)
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml

# Reinicia e habilita containerd
systemctl restart containerd
systemctl enable containerd

# Habilita IP forwarding (necessário para o K8s)
echo "[Common] Habilitando IP forwarding..."
echo "net.ipv4.ip_forward=1" > /etc/sysctl.d/99-kubernetes-ip-forward.conf
sysctl --system

# Instala Kubernetes (v1.30)
echo "[Common] Instalando kubeadm, kubelet e kubectl..."
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /" | tee /etc/apt/sources.list.d/kubernetes.list

apt-get update
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl

# Desabilita swap (obrigatório para o kubeadm)
echo "[Common] Desabilitando swap..."
swapoff -a
sed -i '/ swap / s/^/#/' /etc/fstab
