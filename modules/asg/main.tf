resource "aws_autoscaling_group" "demo" {
  
  name                 = var.name
  desired_capacity     = var.desired_capacity
  launch_configuration = var.lc
  max_size             = var.max_size
  min_size             = var.min_size
  vpc_zone_identifier  = var.vpc_zi 

  tag {
    key                 = "Name"
    value               = var.name
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${var.name}"
    value               = "owned"
    propagate_at_launch = true
  }
}