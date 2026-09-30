variable "project_name" {
  description = "Name prefix applied to every resource"
  type        = string
}

variable "db_subnet_ids" {
  description = "Private database subnet IDs from the network module"
  type        = list(string)
}

variable "security_group_id" {
  description = "RDS security group ID from the network module"
  type        = string
}

variable "db_name" {
  description = "Name of the EpicBook database"
  type        = string
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
}

variable "db_engine_version" {
  description = "MySQL engine version"
  type        = string
}

variable "db_allocated_storage" {
  description = "RDS storage in GB"
  type        = number
}

variable "db_username" {
  description = "RDS master username"
  type        = string
}

variable "db_password" {
  description = "RDS master password, ephemeral so it never reaches state"
  type        = string
  sensitive   = true
  ephemeral   = true
}

variable "db_password_version" {
  description = "Version counter for the write-only password"
  type        = number
}
