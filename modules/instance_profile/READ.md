This is an example for you to use when importing this module:

module "instance_profile" {
  source = "./modules/instance_profile"

  name   = "terraform-eks-demo-cluster-name"
  role   = aws_iam_role.demo-node.name

}
