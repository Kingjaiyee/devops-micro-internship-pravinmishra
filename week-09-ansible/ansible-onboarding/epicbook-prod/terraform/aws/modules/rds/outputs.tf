# The endpoint is exposed so the application can reach the database.
# The password is deliberately never output.
output "rds_endpoint" {
  description = "Connection endpoint of the RDS MySQL instance"
  value       = aws_db_instance.epicbook.endpoint
}

output "rds_address" {
  description = "Hostname of the RDS MySQL instance"
  value       = aws_db_instance.epicbook.address
}

output "db_subnet_group_name" {
  description = "Name of the DB subnet group"
  value       = aws_db_subnet_group.epicbook.name
}
