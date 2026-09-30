output "instance_id" {
  description = "ID of the EpicBook EC2 instance"
  value       = aws_instance.epicbook.id
}

output "public_ip" {
  description = "Public IP address of the EpicBook EC2 instance"
  value       = aws_instance.epicbook.public_ip
}
