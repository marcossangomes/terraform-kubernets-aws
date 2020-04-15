locals {
  
  config_map_aws_auth = <<CONFIGMAPAWSAUTH
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: ${module.role-eks.aws_iam_role_demo_node}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
CONFIGMAPAWSAUTH

  kubeconfig = <<KUBECONFIG
apiVersion: v1
clusters:
- cluster:
    server: ${module.master-cluster-eks.aws_eks_cluster_demo_endpoint}
    certificate-authority-data: ${module.master-cluster-eks.aws_eks_cluster_demo_certificate}
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: aws
  name: aws
current-context: aws
kind: Config
preferences: {}
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws-iam-authenticator
      args:
        - "token"
        - "-i"
        - "terraform-eks-demo"
KUBECONFIG

}


provider "aws" {
  region = "us-east-1"  

}


#Create VPC, SUBNET, INTERNET-GATEWAY, ROUTE-TABLE, ROUTE-TABLE-ASSOSSIATION
module "vpc" {
  source = "./modules/vpc"

  region                 = "us-east-1"
  name                   = "terraform-eks-demo"
  cidr_block_vpc         = "10.0.0.0/16"
  cidr_block_route_table = "0.0.0.0/0"
  
}


#Create role-eks
module "role-eks" {
  source = "./modules/role"

  name  = "terraform-eks-demo"
  
}


#Create SG from master cluster
module "sg-egress" {
  source = "./modules/sg-egress"

  name            = "terraform-eks-demo"
  description     = "Cluster communication with worker nodes"
  vpc_id          = module.vpc.aws_vpc_demo_id
  to_port         = 0
  from_port       = 0
  protocol        = "-1"
  cidr_block      = ["0.0.0.0/0"]
  status          = ""
}


#Create security group rule for master cluster
module "sg-rule-mc" {
  source = "./modules/sg-rule"
  
  # cidr_block                     = ["0.0.0.0/0"]
  description                    = "Allow workstation to communicate with the cluster API Server"
  from_port                      = 443
  to_port                        = 443
  protocol                       = "tcp"
  security_group_demo_cluster_id = module.sg-egress.aws_security_group_demo_cluster_id
  security_group_demo_node_id    = module.sg-egress.aws_security_group_demo_cluster_id
  type                           = "ingress"

}


#Create master cluster
module "master-cluster-eks" {
  source = "./modules/eks-cluster"
  
  name                       = "terraform-eks-demo"
  aws_iam_role_demo_node_arn = module.role-eks.aws_iam_role_demo_node
  sg_demo_cluster_id         = module.sg-egress.sg_demo_cluster_id
  aws_subnet_demo_id         = module.vpc.aws_subnet_demo
  aws_iam_role_policy_attachment_demo_cluster_AmazonEKSClusterPolicy =  module.role-eks.aws_iam_role_demo_node_name
  
}


#Create role-woker-node
module "role-worker-node" {
  source = "./modules/role"

  name  = "terraform-eks-demo-cluster"
  
}


# Create SG from worker node
module "sg-workernode" {
  source = "./modules/sg-egress"

  name            = "terraform-eks-demo-node"
  description     = "Security group for all nodes in the cluster"
  vpc_id          = module.vpc.aws_vpc_demo_id
  from_port       = 0
  to_port         = 0
  protocol        = "-1"
  cidr_block      = ["0.0.0.0/0"]
  status          = "owned"

}


#Create security group rule for master cluster
module "sg-rule-worker-node-1" {
  source = "./modules/sg-rule"
  
  # cidr_block                     = ["0.0.0.0/0"]
  description                    = "Allow node to communicate with each other"
  from_port                      = 0
  protocol                       = "-1"
  security_group_demo_cluster_id = module.sg-workernode.aws_security_group_demo_cluster_id
  security_group_demo_node_id    = module.sg-workernode.aws_security_group_demo_cluster_id
  to_port                        = 65535
  type                           = "ingress"

}


#Create security group rule for master cluster
module "sg-rule-worker-node-2" {
  source = "./modules/sg-rule"
  
  # cidr_block                     = ["0.0.0.0/0"]
  description                    = "Allow worker Kubelets and pods to receive communication from the cluster control panel"
  from_port                      = 1025
  protocol                       = "tcp"
  security_group_demo_cluster_id = module.sg-workernode.aws_security_group_demo_cluster_id
  security_group_demo_node_id    = module.sg-egress.aws_security_group_demo_cluster_id
  to_port                        = 65535
  type                           = "ingress"

}


#Worker node access to EKS Master Cluster
module "sg-rule-worker-acc-eks-mc" {
  source = "./modules/sg-rule"
  
  # cidr_block                     = [""]
  description                    = "Allow pods to communicate with the cluster API Server"
  from_port                      = 443
  protocol                       = "tcp"
  security_group_demo_cluster_id = module.sg-workernode.aws_security_group_demo_cluster_id
  security_group_demo_node_id    = module.sg-egress.aws_security_group_demo_cluster_id
  to_port                        = 443
  type                           = "ingress"

}


#ami from eks
module "ami" {
  source = "./modules/ami"

  name   = "name"
  value  = ["amazon-eks-node-${module.master-cluster-eks.aws_eks_cluster_demo_version}-v*"]

}


module "instance_profile" {
  source = "./modules/instance_profile"

  name   = "terraform-eks-demo"
  role   = module.role-eks.aws_iam_role_demo_node_name

}


#aws_launch_configuration.demo.id
module "lc" { 
  source = "./modules/lc"

  associate_public_ip_address      = true
  iam_instance_profile             = module.instance_profile.inst_profile_demo_node_name
  image_id                         = module.ami.ami_eks_worker_id
  name                             = "terraform-eks-demo"
  instance_type                    = "t2.micro"
  name_prefix                      = "terraform-eks-demo"
  security_groups                  = module.sg-workernode.aws_security_group_demo_cluster_id
  aws_eks_cluster_demo_endpoint    = module.master-cluster-eks.aws_eks_cluster_demo_version
  aws_eks_cluster_demo_certificate = module.master-cluster-eks.aws_eks_cluster_demo_certificate
 
}


module "asg" {
  source = "./modules/asg"

  name             = "terraform-eks-demo"
  desired_capacity = 2
  lc               = module.lc.aws_launch_configuration_demo_id
  max_size         = 2
  min_size         = 1
  vpc_zi           = module.vpc.aws_subnet_demo
  
}