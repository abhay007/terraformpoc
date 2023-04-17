# AWS VPC
resource "aws_vpc" "Paymentology" {
  cidr_block = "10.20.20.0/26"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    "Name" = "Paymentology"
  }
}
#AWS Private Subnet 
resource "aws_subnet" "private" {
  count             = length(var.subnet_cidr_private)
  vpc_id            = aws_vpc.Paymentology.id
  cidr_block        = var.subnet_cidr_private[count.index]
  availability_zone = var.availability_zone[count.index]
  tags = {
    "Name" = "Paymentology-private"
  }
}
#AWS Route Table
resource "aws_route_table" "Paymentology-rt" {
  vpc_id = aws_vpc.Paymentology.id
  tags = {
    "Name" = "Paymentology-route-table"
  }
}
#AWS Route Table Association
resource "aws_route_table_association" "private" {
  count          = length(var.subnet_cidr_private)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.Paymentology-rt.id
}
#AWS Internet Gateway
resource "aws_internet_gateway" "Paymentology-igw" {
  vpc_id = aws_vpc.Paymentology.id
  tags = {
    "Name" = "Paymentology-gateway"
  }
}
#Route Setting
resource "aws_route" "internet-route" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.Paymentology-rt.id
  gateway_id             = aws_internet_gateway.Paymentology-igw.id
}