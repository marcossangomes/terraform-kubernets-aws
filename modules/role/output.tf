#Expose role arn
output "aws_iam_role_demo_node" {
  value = aws_iam_role.demo-node.arn
}

# Expose role name
output "aws_iam_role_demo_node_name" {
  value = aws_iam_role.demo-node.name
}




