# terraform-kubernets-aws
Repositório com exemplo de um terraform modulado para subir um ambiente de Kubernet na AWS.

- Baixe o repositório
- Parametrize os dados que deseja em main.tf
- Execute terraform apply


Esse projeto provisiona/recupera os seguintes recursos:
- VPC
- Subnets
- Internet Gateway
- Routing Tables
- Roles
- Attach policies
- Rules
- AMI
- Security Groups
- Instance Profile
- Launch Configuration
- AutoScaling Group
- Cluster EKS
- Worker EKS
- Locals para configurações do Kubernets
