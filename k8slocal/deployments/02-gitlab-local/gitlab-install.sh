#!/bin/bash
set -e

echo "[GitLab] Adicionando repositório Helm do GitLab..."
helm repo add gitlab https://charts.gitlab.io/
helm repo update

echo "[GitLab] Criando namespace 'gitlab'..."
kubectl create namespace gitlab || true

echo "[GitLab] Criando arquivo de valores personalizados..."
cat <<EOF > gitlab-values.yaml
global:
  edition: ce
  hosts:
    domain: 192.168.56.10.nip.io
    externalIP: 192.168.56.10
    gitlab:
      name: gitlab.192.168.56.10.nip.io
  ingress:
    configureCertmanager: false
    class: nginx
    tls:
      enabled: false
certmanager:
  install: false
nginx-ingress:
  enabled: false
EOF

echo "[GitLab] Instalando GitLab com Helm (isso pode levar vários minutos)..."
helm upgrade --install gitlab gitlab/gitlab \
  --namespace gitlab \
  -f gitlab-values.yaml

echo "[GitLab] Aguardando pods estarem prontos..."
kubectl -n gitlab wait --for=condition=available deploy/gitlab-webservice-default --timeout=600s || true

echo ""
echo "✅ GitLab em Kubernetes instalado com sucesso!"
echo "🌐 Acesse: http://gitlab.192.168.56.10.nip.io"
echo "📌 Para pegar a senha do root, use:"
echo "kubectl -n gitlab get secret gitlab-gitlab-initial-root-password -ojsonpath='{.data.password}' | base64 -d && echo"
