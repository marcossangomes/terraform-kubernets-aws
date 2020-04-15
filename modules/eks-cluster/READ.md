This is an example for you to use when importing this module:

module "master-cluster-eks" {
  source = "./modules/eks-cluster"
  
  name                       = "terraform-eks-demo-cluster-name"
  aws_iam_role_demo_node_arn = aws_iam_role.demo-node.arn
  sg_demo_cluster_id         = [aws_security_group.demo-cluster.id]
  aws_subnet_demo_id         = aws_subnet.demo.*.id
  aws_iam_role_policy_attachment_demo_cluster_AmazonEKSClusterPolicy =  aws_iam_role_policy_attachment.demo-cluster-AmazonEKSClusterPolicy
  
}