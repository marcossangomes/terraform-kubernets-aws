# Expose security group
output "sg_demo_cluster_id" {
  value = aws_security_group.demo-cluster
}

# Expose security group id
output "aws_security_group_demo_cluster_id" {
  value = aws_security_group.demo-cluster.id
}
