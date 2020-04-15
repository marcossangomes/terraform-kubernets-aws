data "aws_ami" "eks-worker" {
   filter {
     name   = var.name
     values = var.value
   }

   most_recent = true
   owners      = ["602401143452"] # Amazon EKS AMI Account ID
 }