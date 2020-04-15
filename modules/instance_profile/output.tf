# Expose the instance profile name
output "inst_profile_demo_node_name" {
  value = aws_iam_instance_profile.demo-node.name
}
