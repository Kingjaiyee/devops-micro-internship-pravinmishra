variable "project_name" {
  description = "Name prefix applied to every resource"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for the EpicBook server"
  type        = string
}

variable "public_key_path" {
  description = "Path to the SSH public key registered with AWS"
  type        = string
}

variable "subnet_id" {
  description = "Public subnet ID from the network module"
  type        = string
}

variable "security_group_id" {
  description = "EC2 security group ID from the network module"
  type        = string
}
