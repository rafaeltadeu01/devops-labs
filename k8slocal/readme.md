
# 🧪 Laboratório Local Kubernetes com Vagrant + VirtualBox

Este projeto configura automaticamente um cluster Kubernetes local com **1 master e 2 workers**, utilizando **Vagrant**, **VirtualBox** e **Debian 12**, com **containerd** como runtime de contêiner. Ideal para testes, aprendizado e automação de ambientes Kubernetes em sua máquina local.

---

## 🔧 Ferramentas Utilizadas

| Ferramenta        | Versão Recomendada | Descrição                                         |
|-------------------|--------------------|--------------------------------------------------|
| [**Vagrant**](https://developer.hashicorp.com/vagrant/downloads) | 2.4.1+             | Gerenciador de ambientes virtuais automatizados |
| [**VirtualBox**](https://www.virtualbox.org/wiki/Downloads)       | 7.x                | Sistema de virtualização para as VMs             |
| **Sistema Host**  | Windows 10/11       | Ambiente local de desenvolvimento                |
| **Box Vagrant**   | `generic/debian12`  | Imagem base das VMs (com suporte para K8s)       |

---

## 📁 Estrutura do Projeto

```
k8slocal/
├── Vagrantfile              # Define as VMs e o provisionamento
└── scripts/
    ├── common.sh            # Instala containerd, kubeadm, kubelet, kubectl e configura o SO
    ├── master.sh            # Inicializa o cluster e aplica o Flannel
    ├── worker.sh            # Executa o join dos workers
    └── reset.sh             # Reseta o cluster local sem destruir as VMs
```

---

## 🌐 Topologia do Cluster

Rede privada: `192.168.56.0/24`

```
+----------------+           +----------------+           +----------------+
|  k8s-master    |           |   k8s-node1    |           |   k8s-node2    |
|  192.168.56.10 |           | 192.168.56.21  |           | 192.168.56.22  |
| Control Plane  |           | Worker Node    |           | Worker Node    |
+----------------+           +----------------+           +----------------+
```

---

## 🚀 Como Subir o Cluster

### 1. Instale as ferramentas

No seu Windows:

- [Vagrant](https://developer.hashicorp.com/vagrant/downloads)
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads)

Verifique com:

```bash
vagrant --version
VBoxManage --version
```

### 2. Clone ou crie a estrutura

```bash
git clone <seu-repo> k8slocal
cd k8slocal
```

### 3. Suba o ambiente

```bash
vagrant up
```

### 4. Acesse o master e valide o cluster

```bash
vagrant ssh k8s-master
kubectl get nodes
```

> O `kubectl` já estará configurado tanto para o usuário `vagrant` quanto para o `root`.

---

## 🔁 Reset do Cluster (sem destruir VMs)

Você pode resetar o cluster para reaproveitar as mesmas VMs:

```bash
vagrant ssh k8s-master
sudo /vagrant/reset.sh
```

Ou resetar todas as VMs de uma vez:

```bash
for vm in k8s-master k8s-node1 k8s-node2; do
  vagrant ssh $vm -c "sudo /vagrant/reset.sh"
done
```

---

## ⚙️ Configurações Técnicas

- **Runtime de contêineres:** containerd
- **Cgroup Driver:** systemd
- **Rede de pods (CNI):** Flannel (`10.244.0.0/16`)
- **IP Forwarding:** ativado via `sysctl.d`
- **Swap:** desativado automaticamente pelo script

---

## 📋 Comandos Úteis

| Ação                              | Comando                                      |
|----------------------------------|----------------------------------------------|
| Subir o cluster                  | `vagrant up`                                 |
| Ver status das VMs              | `vagrant status`                             |
| Acessar o master                 | `vagrant ssh k8s-master`                     |
| Ver os nós do cluster            | `kubectl get nodes`                          |
| Resetar cluster na VM           | `sudo /vagrant/reset.sh`                     |
| Resetar todas as VMs            | Ver comando em loop acima                    |
| Desligar as VMs                 | `vagrant halt`                               |
| Destruir tudo                   | `vagrant destroy -f`                         |

---

## 📌 Ideal Para

✅ Estudo de Kubernetes  
✅ Simulação de ambiente de produção local  
✅ Treinamento com `kubeadm`, `kubectl`, `containerd`, CNI  
✅ Testes de automação e scripts de DevOps

---

> Criado para fins educacionais e laboratoriais.  
> Contribuições e melhorias são bem-vindas!
