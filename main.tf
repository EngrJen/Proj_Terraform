# Creating a VPC
resource "aws_vpc" "Prod-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "Prod-vpc"
  }
}