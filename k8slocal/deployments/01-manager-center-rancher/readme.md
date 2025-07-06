# Instalação dos Componetes de gerenciamento do Cluster


# 🐮 Instalação Manual do Rancher em Cluster K8s com Flannel (Projeto k8slocal)

Este documento descreve os passos manuais para instalar o **Rancher** em um cluster Kubernetes local criado com `kubeadm` e rede **Flannel**, sem `helm` ou `ingress` pré-instalados.

---

## ✅ Pré-requisitos

- Cluster Kubernetes funcionando (inicializado com `kubeadm`)
- Rede Flannel aplicada
- Acesso funcional ao `kubectl` (usuário `vagrant` ou `root`)
- Acesso à internet na VM master

---

## 🔧 Etapas de Instalação

### 1. Instalar o Helm

```bash
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
helm version
```

---

### 2. Instalar o Ingress Controller (NGINX)

```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

helm install ingress-nginx ingress-nginx/ingress-nginx \
  --create-namespace --namespace ingress-nginx \
  --set controller.publishService.enabled=true
```

Espere o Ingress estar disponível:

```bash
kubectl wait --namespace ingress-nginx \
  --for=condition=Available deployment/ingress-nginx-controller \
  --timeout=180s
```

---

### 3. Adicionar o repositório do Rancher

```bash
helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
helm repo update
```

---

### 4. Criar o namespace e instalar o Rancher

```bash
kubectl create namespace cattle-system

helm install rancher rancher-latest/rancher \
  --namespace cattle-system \
  --set hostname=rancher.192.168.56.10.nip.io \
  --set replicas=1 \
  --set bootstrapPassword=admin \
  --set ingress.tls.source=secret \
  --set privateCA=true
```

---

### 5. Verificar implantação

```bash
kubectl -n cattle-system rollout status deploy/rancher --timeout=300s
```

---

### 6. Acessar o Rancher

Abra no navegador:

🔗 [https://rancher.192.168.56.10.nip.io](https://rancher.192.168.56.10.nip.io)

> Aceite o alerta de certificado autoassinado.

---

## 🔐 Credenciais Padrão

- **Usuário:** `admin`
- **Senha:** `admin`

---

## 📝 Observações

- O domínio `nip.io` resolve automaticamente para `192.168.56.10`
- Se for usar outro IP ou domínio, substitua no parâmetro `--set hostname=...`

---

##  Script para a execução em lote

- Segue a baixo um script para executar este processo em lote:

[install_rancher.sh][def]

[def]: install_rancher.sh