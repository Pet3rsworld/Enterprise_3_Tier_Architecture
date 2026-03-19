output "alb_sg_id" {
  value       = aws_security_group.alb_sg.id
  description = "ID of ALB Security Group"
}

output "ec2_sg_id" {
  value       = aws_security_group.ec2_sg.id
  description = "ID of EC2 Security Group"
}

output "rds_sg_id" {
  value       = aws_security_group.rds_sg.id
  description = "ID of RDS Security Group"
}

output "ssm_instance_profile_name" {
  value       = aws_iam_instance_profile.ec2_profile.id
  description = "Namme of IAM Instance Profile for EC2"
}
