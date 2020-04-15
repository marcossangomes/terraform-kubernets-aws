resource "aws_eks_cluster" "demo" {
  name                 = var.name
  role_arn             = var.aws_iam_role_demo_node_arn

  vpc_config {
    security_group_ids = [var.sg_demo_cluster_id.id]  
    subnet_ids         = var.aws_subnet_demo_id
  }

  depends_on = [
     var.aws_iam_role_policy_attachment_demo_cluster_AmazonEKSClusterPolicy, 
     var.aws_iam_role_policy_attachment_demo_cluster_AmazonEKSClusterPolicy,
  ]
}