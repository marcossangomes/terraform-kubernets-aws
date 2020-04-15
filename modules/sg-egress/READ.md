This is an example for you to use when importing this module:

module "sg-egress" {
  source = "./modules/sg-egress"

  name            = "terraform-eks-demo"
  description     = "Cluster communication with worker nodes"
  vpc_id          = aws_vpc.demo.id
  to_port         = 0
  from_port       = 0
  protocol        = "-1"
  cidr_block      = ["0.0.0.0/0"]
  status          = ""

}