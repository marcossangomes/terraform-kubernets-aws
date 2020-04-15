This is an example for you to use when importing this module:

module "ami" {
  source = "./modules/ami"

  name   = "name"
  value  = ["amazon-eks-node-v*"]

}