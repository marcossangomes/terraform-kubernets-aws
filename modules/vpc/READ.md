This is an example for you to use when importing this module:

module "vpc" {
  source = "./modules/vpc"

  region                 = "us-east-1"
  name                   = "terraform-eks-demo"
  cidr_block_vpc         = "10.0.0.0/16"
  cidr_block_route_table = "0.0.0.0/0"
  
}