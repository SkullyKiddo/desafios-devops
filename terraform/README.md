# Desafio 01: Infrastructure-as-code - Terraform

## Preparar ambiente
- Garantir que haja uma instalação apropridada do [Terraform](https://www.terraform.io/intro/getting-started/install.html)
- Após clonar o repositório :
  - chmod +x terraform/apply.sh
  - chmod +x terraform/destroy.sh

## Execução
- Para criar a instância deve-se executar o script **terraform/apply.sh** e preencher os parâmetros conforme solicitado
- Para destruir a infraestrutura deve-se executar o script **terraform/destroy.sh** e preencher os parâmetros conforme solicitado

## Funcionamento - Apply
O script executa em quatro passos básicos:
  1. Solicita os parâmetros de acesso, a região em que será provisionada a instância e os IPs (um a um) que serão liberados para acesso via SSH
  2. Criar o arquivo terraform.tfvars com o IPs e região
  3. Executa init e apply do terraform (aguardando a confirmação do usuário)
  4. Ao final o IP público da máquina é apresentado (deve-se aguardar de 1~5 minutos para que a página default do apache seja aprensentada)

## Funcionamento - Destroy
O script executa em dois passos básicos:
  1. Solicita os parâmetros de acesso
  2. Executa init e destroy do terraform (aguardando a confirmação do usuário)

## Descrições técnicas
Para resolver o desafio foram utilizados:
- Linguagem Shell para construção dos scripts de execução *aplly.sh* e *destroy.sh* e o User Data *install-docker.sh*.
- O arquivo main.tf contém todas as especificações da estrutura
- A estrutura é construída na AWS
- A instância usa a última versão da AMI da Canonical - Ubuntu Server 18.04
- O contâiner é compilado (imagem httpd 2.4) e executado no User Data e a página default do Apache é construída no mesmo arquivo

## Débito técnico
Foi adicionado ao .gitignore os arquivos terraform.tfstate e terraform.tfstate.backup. Esses arquivos deveriam estar em *backend* como descrito na [Documentação](https://www.terraform.io/docs/backends/)
