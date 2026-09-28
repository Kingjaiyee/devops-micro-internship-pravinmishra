output "public_ips" {
  description = "Public IP of each server, keyed by server name"
  value       = { for name, instance in aws_instance.server : name => instance.public_ip }
}

output "private_ips" {
  description = "Private IP of each server, keyed by server name"
  value       = { for name, instance in aws_instance.server : name => instance.private_ip }
}

output "server_groups" {
  description = "Ansible group of each server"
  value       = var.servers
}

output "inventory_ini" {
  description = "Ansible inventory generated from the running instances"
  value       = local.inventory_ini
}
