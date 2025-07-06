#!/bin/bash
set -e

echo "[Master] Inicializando o cluster K8s..."

kubeadm init \
  --apiserver-advertise-address=192.168.56.10 \
  --pod-network-cidr=10.244.0.0/16

echo "[Master] Configurando kubeconfig para o usuário vagrant..."
mkdir -p /home/vagrant/.kube
cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown vagrant:vagrant /home/vagrant/.kube/config

echo "[Master] Configurando kubeconfig para o usuário root..."
mkdir -p /root/.kube
cp -i /etc/kubernetes/admin.conf /root/.kube/config

echo "[Master] Aplicando rede Flannel..."
su - vagrant -c "kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml"

echo "[Master] Salvando comando kubeadm join..."
kubeadm token create --print-join-command > /vagrant/join.sh
chmod +x /vagrant/join.sh
