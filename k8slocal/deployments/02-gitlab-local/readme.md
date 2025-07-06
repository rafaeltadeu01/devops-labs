## 🛠️ Pré-requisitos
Este script pressupõe que você:

Já possui um cluster Kubernetes em funcionamento (ex: k8slocal)

Já tem o Helm instalado

Já possui um Ingress Controller ativo (ex: nginx)

Tem acesso a um domínio como gitlab.192.168.56.10.nip.io ou similar

## 📁 Resultado
GitLab CE exposto via Ingress em http://gitlab.192.168.56.10.nip.io

Sem TLS (autoassinado pode ser adicionado depois)

Ingress NGINX utilizado como controlador

## !Observações
O deploy inicial do GitLab pode levar de 5 a 10 minutos dependendo da máquina

Use kubectl get pods -n gitlab para acompanhar o progresso

O nip.io facilita o DNS dinâmico baseado no IP sem necessidade de alterações no hosts