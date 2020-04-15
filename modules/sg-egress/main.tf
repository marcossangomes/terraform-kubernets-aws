
#EKS Master Cluster Security Group
resource "aws_security_group" "demo-cluster" {
  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id

  egress {
    from_port   = var.from_port
    to_port     = var.to_port
    protocol    = var.protocol
    cidr_blocks = var.cidr_block
  }

  tags = {
    "Name"      = var.name
  }
}

