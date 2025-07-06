#!/bin/bash
set -e

ROLE=$(hostname)

echo "[Reset] Iniciando reset em $ROLE..."

# Reset do kubeadm
kubeadm reset -f

# Remove diretórios do K8s
rm -rf ~/.kube /etc/kubernetes /var/lib/etcd /var/lib/kubelet /etc/cni /opt/cni /var/lib/cni

# Limpa interface de rede cni
ip link delete cni0 || true
ip link delete flannel.1 || true

# Remove join.sh se for master
if [[ "$ROLE" == "k8s-master" ]]; then
    rm -f /vagrant/join.sh
fi

echo "[Reset] Reset completo. Reexecutando scripts de inicialização..."

if [[ "$ROLE" == "k8s-master" ]]; then
    /vagrant/master.sh
else
    /vagrant/worker.sh
fi

echo "[Reset] Reconfiguração finalizada para $ROLE."
