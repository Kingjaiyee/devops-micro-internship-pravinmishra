variable "project_name" {
  description = "Name prefix applied to every resource"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
}

variable "private_db_a_cidr" {
  description = "CIDR block for private database subnet A"
  type        = string
}

variable "private_db_b_cidr" {
  description = "CIDR block for private database subnet B"
  type        = string
}

variable "public_subnet_az" {
  description = "Availability Zone for the public subnet"
  type        = string
}

variable "private_db_a_az" {
  description = "Availability Zone for private database subnet A"
  type        = string
}

variable "private_db_b_az" {
  description = "Availability Zone for private database subnet B"
  type        = string
}

variable "my_ip_cidr" {
  description = "My public IP in /32 form, used to restrict SSH"
  type        = string
  sensitive   = true
}
