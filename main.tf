# Creating a VPC
resource "aws_vpc" "Prod-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "Prod-vpc"
  }
}
# Creating Public Subnets
resource "aws_subnet" "Prod-pub-sub1" {
  vpc_id     = aws_vpc.Prod-vpc.id
  cidr_block = "10.0.10.0/24"

  tags = {
    Name = "Prod-pub-sub1"
  }
}
resource "aws_subnet" "Prod-pub-sub2" {
  vpc_id     = aws_vpc.Prod-vpc.id
  cidr_block = "10.0.11.0/24"

  tags = {
    Name = "Prod-pub-sub2"
  }
}
# Creating Private Subnets
resource "aws_subnet" "Prod-priv-sub1" {
  vpc_id     = aws_vpc.Prod-vpc.id
  cidr_block = "10.0.12.0/24"

  tags = {
    Name = "Prod-priv-sub1"
  }
}
resource "aws_subnet" "Prod-priv-sub2" {
  vpc_id     = aws_vpc.Prod-vpc.id
  cidr_block = "10.0.13.0/24"

  tags = {
    Name = "Prod-priv-sub2"
  }
}
# Creating Route-Tables
resource "aws_route_table" "Prod-pub-route-table" {
  vpc_id = aws_vpc.Prod-vpc.id

  tags = {
    Name = "Prod-pub-route-table"
  }
}
resource "aws_route_table" "Prod-priv-route-table" {
  vpc_id = aws_vpc.Prod-vpc.id

  tags = {
    Name = "Prod-priv-route-table"
  }
}
# Public Route Table Association
resource "aws_route_table_association" "Prod-public-route-table-association" {
  subnet_id      = aws_subnet.Prod-pub-sub1.id
  route_table_id = aws_route_table.Prod-pub-route-table.id
}
resource "aws_route_table_association" "Prod-public-route-table-association-2" {
  subnet_id      = aws_subnet.Prod-pub-sub2.id
  route_table_id = aws_route_table.Prod-pub-route-table.id
}
# Private Route Table Association
resource "aws_route_table_association" "Prod-priv-route-table-association" {
  subnet_id      = aws_subnet.Prod-priv-sub1.id
  route_table_id = aws_route_table.Prod-priv-route-table.id
}
resource "aws_route_table_association" "Prod-priv-route-table-association-2" {
  subnet_id      = aws_subnet.Prod-priv-sub2.id
  route_table_id = aws_route_table.Prod-priv-route-table.id
}
# Creating Internet Gateway
resource "aws_internet_gateway" "Prod-igw" {
  vpc_id = aws_vpc.Prod-vpc.id

  tags = {
    Name = "Prod-igw"
  }
}
#IGW Association
resource "aws_route" "igw-route" {
  route_table_id            = aws_route_table.Prod-pub-route-table.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.Prod-igw.id
}
#elastic ip
resource "aws_eip" "Prod_eip" {
  tags = {
    Name= "pro-eip"
  }
}
# NAT Gateway
resource "aws_nat_gateway" "Prod-nat-gateway" {
  allocation_id = aws_eip.Prod_eip.id
  subnet_id = aws_subnet.Prod-pub-sub1.id
}
# NAT Gateway Routing
resource "aws_route" "private-route" {
  route_table_id = aws_route_table.Prod-priv-route-table.id
  gateway_id = aws_nat_gateway.Prod-nat-gateway.id
  destination_cidr_block = "0.0.0.0/0"

}
