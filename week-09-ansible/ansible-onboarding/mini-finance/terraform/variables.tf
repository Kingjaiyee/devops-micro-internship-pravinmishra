variable "location" {
  description = "Azure region for the lab"
  type        = string
  default     = "swedencentral"
}

variable "project_name" {
  description = "Name used in resource names"
  type        = string
  default     = "mini-finance"
}

variable "vm_size" {
  description = "Azure VM size"
  type        = string
  default     = "Standard_B1s"
}

variable "admin_username" {
  description = "Linux admin user on the VM"
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key_path" {
  description = "Public key of the Ansible controller, installed for the admin user"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}

variable "vnet_cidr" {
  description = "Address space for the virtual network"
  type        = string
  default     = "10.40.0.0/16"
}

variable "subnet_cidr" {
  description = "Address range for the VM subnet"
  type        = string
  default     = "10.40.1.0/24"
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
