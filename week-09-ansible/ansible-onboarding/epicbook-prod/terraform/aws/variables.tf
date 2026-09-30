variable "aws_region" {
  description = "AWS region for all resources"
  type        = string
  default     = "eu-north-1"
}

variable "project_name" {
  description = "Name prefix applied to every resource"
  type        = string
  default     = "epicbook-prod"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.50.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.50.1.0/24"
}

variable "private_db_a_cidr" {
  description = "CIDR block for private database subnet A"
  type        = string
  default     = "10.50.11.0/24"
}

variable "private_db_b_cidr" {
  description = "CIDR block for private database subnet B"
  type        = string
  default     = "10.50.12.0/24"
}

variable "public_subnet_az" {
  description = "Availability Zone for the public subnet"
  type        = string
  default     = "eu-north-1a"
}

variable "private_db_a_az" {
  description = "Availability Zone for private database subnet A"
  type        = string
  default     = "eu-north-1a"
}

variable "private_db_b_az" {
  description = "Availability Zone for private database subnet B, must differ from A"
  type        = string
  default     = "eu-north-1b"
}

variable "instance_type" {
  description = "EC2 instance type for the EpicBook server"
  type        = string
  default     = "t3.small"
}

variable "public_key_path" {
  description = "Path to the Ansible controller SSH public key registered with AWS"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}

variable "db_name" {
  description = "Name of the EpicBook database (the seed SQL expects bookstore)"
  type        = string
  default     = "bookstore"
}

variable "db_username" {
  description = "RDS master username"
  type        = string
  default     = "epicadmin"
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "db_engine_version" {
  description = "MySQL engine version. 8.0 is in paid Extended Support, so 8.4"
  type        = string
  default     = "8.4"
}

variable "db_allocated_storage" {
  description = "RDS storage in GB"
  type        = number
  default     = 20
}

# Secrets below come from TF_VAR_ environment variables set by lab.env.
variable "my_ip_cidr" {
  description = "Controller public IP in /32 form, used to restrict SSH"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "RDS master password. Ephemeral: used for the write-only argument, never stored in state"
  type        = string
  sensitive   = true
  ephemeral   = true
}

variable "db_password_version" {
  description = "Bump this number to push a new db_password to RDS"
  type        = number
  default     = 1
}
