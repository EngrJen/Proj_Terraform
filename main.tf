# Creating a VPC
resource "aws_vpc" "Prod_vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "Prod_vpc"
  }
}
# Creating Public Subnets
resource "aws_subnet" "Prod_pub_sub1" {
  vpc_id     = aws_vpc.Prod_vpc.id
  cidr_block = var.Prod_pub_sub1_cidr

  tags = {
    Name = "Prod_pub_sub1"
  }
}
resource "aws_subnet" "Prod_pub_sub2" {
  vpc_id     = aws_vpc.Prod_vpc.id
  cidr_block = var.Prod_pub_sub2_cidr

  tags = {
    Name = "Prod_pub_sub2"
  }
}
# Creating Private Subnets
resource "aws_subnet" "Prod_priv_sub1" {
  vpc_id     = aws_vpc.Prod_vpc.id
  cidr_block = var.Prod_priv_sub1_cidr

  tags = {
    Name = "Prod_priv_sub1"
  }
}
resource "aws_subnet" "Prod_priv_sub2" {
  vpc_id     = aws_vpc.Prod_vpc.id
  cidr_block = var.Prod_priv_sub2_cidr

  tags = {
    Name = "Prod_priv_sub2"
  }
}
# Creating Route-Tables
resource "aws_route_table" "Prod_pub_route_table" {
  vpc_id = aws_vpc.Prod_vpc.id

  tags = {
    Name = "Prod_pub_route_table"
  }
}
resource "aws_route_table" "Prod_priv_route_table" {
  vpc_id = aws_vpc.Prod_vpc.id

  tags = {
    Name = "Prod_priv_route_table"
  }
}
# Public Route Table Association
resource "aws_route_table_association" "Prod_pub_route_table_association" {
  subnet_id      = aws_subnet.Prod_pub_sub1.id
  route_table_id = aws_route_table.Prod_pub_route_table.id
}
resource "aws_route_table_association" "Prod_pub_route_table_association-2" {
  subnet_id      = aws_subnet.Prod_pub_sub2.id
  route_table_id = aws_route_table.Prod_pub_route_table.id
}
# Private Route Table Association
resource "aws_route_table_association" "Prod_priv_route_table_association" {
  subnet_id      = aws_subnet.Prod_priv_sub1.id
  route_table_id = aws_route_table.Prod_priv_route_table.id
}
resource "aws_route_table_association" "Prod_priv_route_table_association-2" {
  subnet_id      = aws_subnet.Prod_priv_sub2.id
  route_table_id = aws_route_table.Prod_priv_route_table.id
}
# Creating Internet Gateway
resource "aws_internet_gateway" "Prod_igw" {
  vpc_id = aws_vpc.Prod_vpc.id

  tags = {
    Name = "Prod_igw"
  }
}
#IGW Association
resource "aws_route" "igw_route" {
  route_table_id            = aws_route_table.Prod_pub_route_table.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.Prod_igw.id
}
#elastic ip
resource "aws_eip" "Prod_eip" {
  tags = {
    Name= "Prod_eip"
  }
}
# NAT Gateway
resource "aws_nat_gateway" "Prod_nat_gateway" {
  allocation_id = aws_eip.Prod_eip.id
  subnet_id = aws_subnet.Prod_pub_sub1.id
}
# NAT Gateway Routing
resource "aws_route" "private_route" {
  route_table_id = aws_route_table.Prod_priv_route_table.id
  gateway_id = aws_nat_gateway.Prod_nat_gateway.id
  destination_cidr_block = "0.0.0.0/0"

}
