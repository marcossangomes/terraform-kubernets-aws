# Expse vpc id
output "aws_vpc_demo_id" {
  value = aws_vpc.demo.id
}

# Expose subnets ids
output "aws_subnet_demo" {
  value = aws_subnet.demo.*.id
}

