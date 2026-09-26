variable "aws_region" {
  description = "AWS region for the drift lab"
  type        = string
  default     = "eu-north-1"
}

variable "availability_zone" {
  description = "Availability Zone for the lab subnet"
  type        = string
  default     = "eu-north-1a"
}

variable "vpc_cidr" {
  description = "CIDR block for the lab VPC"
  type        = string
  default     = "10.90.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for the lab subnet"
  type        = string
  default     = "10.90.1.0/24"
}

# Supplied through TF_VAR_my_ip_cidr so the operator IP is never written
# to a file. Marked sensitive so it does not appear in plan output.
variable "my_ip_cidr" {
  description = "Operator public IP in /32 form, allowed to reach SSH"
  type        = string
  sensitive   = true
}
