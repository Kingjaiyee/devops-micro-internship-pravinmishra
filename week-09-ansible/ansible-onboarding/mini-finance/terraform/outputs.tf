output "public_ip" {
  description = "Public IP of vm-mini-finance"
  value       = azurerm_public_ip.pip.ip_address
}

output "admin_username" {
  description = "SSH user on the VM"
  value       = var.admin_username
}

output "inventory_ini" {
  description = "Ansible inventory generated from the deployed VM"
  value = join("\n", [
    "[web]",
    "mini-finance ansible_host=${azurerm_public_ip.pip.ip_address}",
    "",
    "[web:vars]",
    "ansible_user=${var.admin_username}",
    ""
  ])
}
