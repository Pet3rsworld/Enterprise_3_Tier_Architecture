variable "project_name" {
  type        = string
  description = "Name of the project"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs for RDS subnet group"
}

variable "rds_sg_id" {
  type        = string
  description = "ID of RDS Database Security Group"
}

# Temporarily inject password before Terraform Apply
variable "rds_password" {
  type        = string
  description = "Password for the RDS instance"
  sensitive   = true
}
