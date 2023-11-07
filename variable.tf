variable "region" {
  description = "aws region"
  default     = "eu-west-2"
}

variable "vpc_cidr" {
  description = "vpc cidr"
  default     = "10.0.0.0/16"
}

variable "Prod_pub_sub1_cidr" {
  description = "Prod_pub_sub1_cidr"
  default     = "10.0.10.0/24"
}

variable "Prod_pub_sub2_cidr" {
  description = "Prod_pub_sub2_cidr"
  default     = "10.0.11.0/24"
}

variable "Prod_priv_sub1_cidr" {
  description = "Prod_priv_sub1_cidr"
  default     = "10.0.12.0/24"
}

variable "Prod_priv_sub2_cidr" {
  description = "Prod_priv_sub2_cidr"
  default     = "10.0.13.0/24"
}

