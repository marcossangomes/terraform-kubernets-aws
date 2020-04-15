data "aws_region" "current" {
}
# EKS currently documents this required userdata for EKS worker nodes to
# properly configure Kubernetes applications on the EC2 instance.
# We implement a Terraform local here to simplify Base64 encoding this
# information into the AutoScaling Launch Configuration.
# More information: https://docs.aws.amazon.com/eks/latest/userguide/launch-workers.html
locals {
  demo-node-userdata = <<USERDATA
#!/bin/bash
set -o xtrace /etc/eks/bootstrap.sh --apiserver-endpoint '${var.aws_eks_cluster_demo_endpoint}' --b64-cluster-ca '${var.aws_eks_cluster_demo_certificate}' '${var.name}'
USERDATA

}

resource "aws_launch_configuration" "demo" {
  associate_public_ip_address = var.associate_public_ip_address
  iam_instance_profile        = var.iam_instance_profile
  image_id                    = var.image_id
  instance_type               = var.instance_type
  name_prefix                 = var.name_prefix
  security_groups             = [var.security_groups]
  user_data_base64            = base64encode(local.demo-node-userdata)

  lifecycle {
    create_before_destroy     = true
  }
}