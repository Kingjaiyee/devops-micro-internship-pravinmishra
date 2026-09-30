output "ec2_instance_id" {
  description = "ID of the EpicBook EC2 instance"
  value       = module.ec2.instance_id
}

output "ec2_public_ip" {
  description = "Public IP address of the EpicBook EC2 instance"
  value       = module.ec2.public_ip
}

output "ssh_user" {
  description = "Login user for the Ubuntu AMI"
  value       = "ubuntu"
}

output "rds_endpoint" {
  description = "Endpoint (host:port) of the private RDS MySQL instance"
  value       = module.rds.rds_endpoint
}

output "rds_address" {
  description = "Hostname of the private RDS MySQL instance, used by Ansible"
  value       = module.rds.rds_address
}

output "db_name" {
  description = "EpicBook database name"
  value       = var.db_name
}

output "db_username" {
  description = "RDS master username. The password is never output"
  value       = var.db_username
}

output "inventory_ini" {
  description = "Ansible inventory generated from the running instance"
  value = join("\n", [
    "[web]",
    "epicbook ansible_host=${module.ec2.public_ip}",
    "",
    "[web:vars]",
    "ansible_user=ubuntu",
    "ansible_ssh_private_key_file=~/.ssh/id_ed25519",
    ""
  ])
}
