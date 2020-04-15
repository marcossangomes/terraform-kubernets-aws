# Expose eks-cluster endpoint
output "aws_eks_cluster_demo_endpoint" {
  value = aws_eks_cluster.demo.endpoint
}

# Expose eks-cluster certificate
output "aws_eks_cluster_demo_certificate" {
  value = aws_eks_cluster.demo.certificate_authority.0.data
}

# Expose eks-cluster version
output "aws_eks_cluster_demo_version" {
  value = aws_eks_cluster.demo.version
}

