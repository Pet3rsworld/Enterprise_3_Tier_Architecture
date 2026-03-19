# Temporarily inject password before Terraform Apply
variable "rds_password" {
  type        = string
  description = "Password for the RDS instance"
  sensitive   = true
}
