data "aws_availability_zones" "available" {
 }

 resource "aws_vpc" "demo" {
   cidr_block  = var.cidr_block_vpc

   tags = {
     "Name"                                      = var.name
     "kubernetes.io/cluster/${var.name}" = "shared"
   }
 }

 resource "aws_subnet" "demo" {
   count = 2

   availability_zone = data.aws_availability_zones.available.names[count.index]
   cidr_block        = "10.0.${count.index}.0/24"
   vpc_id            = aws_vpc.demo.id

   tags = {
     "Name"                                      = var.name
     "kubernetes.io/cluster/${var.name}" = "shared"
   }
 }

 resource "aws_internet_gateway" "demo" {
   vpc_id = aws_vpc.demo.id

   tags = {
     Name = var.name
   }
 }

 resource "aws_route_table" "demo" {
   vpc_id = aws_vpc.demo.id

   route {
     cidr_block = var.cidr_block_route_table
     gateway_id = aws_internet_gateway.demo.id
   }
 }

 resource "aws_route_table_association" "demo" {
   count = 2

   subnet_id      = aws_subnet.demo[count.index].id
   route_table_id = aws_route_table.demo.id
 }