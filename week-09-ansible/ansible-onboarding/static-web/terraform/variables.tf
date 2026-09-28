variable "aws_region" {
  description = "AWS region for the lab"
  type        = string
  default     = "eu-north-1"
}

variable "project_name" {
  description = "Prefix used in resource names"
  type        = string
  default     = "static-web"
}

variable "servers" {
  description = "Server name mapped to its Ansible group"
  type        = map(string)
  default = {
    web1 = "web"
    web2 = "web"
  }

  validation {
    condition     = length(var.servers) == 2 && alltrue([for group in values(var.servers) : group == "web"])
    error_message = "This assignment uses exactly two servers, both in the web group."
  }
}

variable "instance_type" {
  description = "EC2 instance type for every server"
  type        = string
  default     = "t3.micro"
}

variable "vpc_cidr" {
  description = "CIDR block for the lab VPC"
  type        = string
  default     = "10.30.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.30.1.0/24"
}

variable "ssh_public_key_path" {
  description = "Public key of the Ansible controller, installed on every server"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}

variable "controller_ip" {
  description = "Public IPv4 of the Ansible controller. Supply via TF_VAR_controller_ip (source lab.env)."
  type        = string
  sensitive   = true

  validation {
    condition     = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}$", var.controller_ip))
    error_message = "controller_ip must be a plain IPv4 address. Run: source lab.env"
  }
}
