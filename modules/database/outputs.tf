output "rds_endpoint" {
  value       = aws_db_instance.rds_instance.endpoint
  description = "Endpoint address for the RDS database"
}
