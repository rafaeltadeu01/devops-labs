#!/bin/bash
set -e

echo "[Rancher] Instalando Helm..."
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

echo "[Rancher] Verificando versão do Helm..."
helm version

echo "[Rancher] Adicionando repositório do Ingress NGINX..."
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

echo "[Rancher] Instalando Ingress NGINX..."
helm install ingress-nginx ingress-nginx/ingress-nginx \
  --create-namespace --namespace ingress-nginx \
  --set controller.publishService.enabled=true \
  --timeout 10m

echo "[Rancher] Aguardando o Ingress NGINX ficar disponível..."
kubectl wait --namespace ingress-nginx \
  --for=condition=Available deployment/ingress-nginx-controller \
  --timeout=180s

echo "[Rancher] Adicionando repositório do Rancher..."
helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
helm repo update

echo "[Rancher] Criando namespace cattle-system..."
kubectl create namespace cattle-system || true

echo "[Rancher] Instalando Rancher..."
helm install rancher rancher-latest/rancher \
  --namespace cattle-system \
  --set hostname=rancher.192.168.56.10.nip.io \
  --set replicas=1 \
  --set bootstrapPassword=admin \
  --set ingress.tls.source=secret \
  --set privateCA=true

echo "[Rancher] Aguardando Rancher ficar disponível..."
kubectl -n cattle-system rollout status deploy/rancher --timeout=300s

echo "[Rancher] Rancher instalado com sucesso!"
echo "Acesse: https://rancher.192.168.56.10.nip.io"
echo "Login: admin | Senha: admin"
echo "[Rancher] Verificando status do Rancher..."
kubectl -n cattle-system get pods