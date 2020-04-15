This is an example for you to use when importing this module:

module "asg" {
  source = "./modules/asg"

  name             = "terraform-eks-demo-cluster-name"
  desired_capacity = 2
  lc               = aws_launch_configuration.demo.id
  max_size         = 2
  min_size         = 1
  vpc_zi           = [aws_subnet.demo.0.id]
  
}