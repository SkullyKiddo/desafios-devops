# Desafio 02: Kubernetes

## Preparar ambiente
- Instalar os seguintes componentes:
  - [Minikube](https://kubernetes.io/docs/tasks/tools/install-minikube/)
  - [HELM](https://docs.helm.sh/using_helm/#installing-helm)
  - [Docker](https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-docker-ce)
- Após clonar o repositório :
  - chmod +x run.sh
  
## Execução
- Para criar o cluster deve-se executar o script **run.sh**

## Funcionamento - Run
O script executa da seguinte forma:
1. Configura o Minikube como a [documentação](https://kubernetes.io/docs/setup/minikube/) sugere e habilita o *ingress*
2. Compila a imagem Docker
3. Usa o HELM para instalar os manifestos de deploy, serviço e ingress (divididos no namespace *idwall-app*)
4. Insere o host configurado pelo ingress no arquivo /etc/hosts caso não exista
5. Exibe ao operador o host para acessar a aplicação

## Descrições técnicas
Para resolver o desafio foram utilizados:
- Linguagem Shell para construção do script de execução *run.sh*
- Templates HELM para instalar e administrar os releases (deployment, service e ingress)
- Minikube para construir o Cluster local com Kubernetes
- Compilação da imagem Node utilizando Docker
- O script foi testado utilizando a distribuição do Ubuntu Desktop 18.04 (Bionic Beaver)

## Débito técnico
Os templates HELM não foram parametrizados para receberem os valores dinamicamente. Para que sejam possíveis deploys de versões diferentes em diferentes ambientes, parametrizar é a melhor prática.
