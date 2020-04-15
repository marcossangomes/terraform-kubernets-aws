This is an example for you to use when importing this module:

module "lc" { 
  source = "./modules/lc"

  associate_public_ip_address      = true
  iam_instance_profile             = aws_iam_instance_profile.demo-node.name
  image_id                         = data.aws_ami.eks-worker.id
  name                             = "terraform-eks-demo"
  instance_type                    = "t2.micro"
  name_prefix                      = "terraform-eks-demo"
  security_groups                  = [aws_security_group.demo-node.id]
  aws_eks_cluster_demo_endpoint    = aws_eks_cluster.demo.endpoint
  aws_eks_cluster_demo_certificate = aws_eks_cluster. demo.certificate_authority[0].data
 
}
