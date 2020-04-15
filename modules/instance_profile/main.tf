resource "aws_iam_instance_profile" "demo-node" {
  name = var.name
  role = var.role 
}