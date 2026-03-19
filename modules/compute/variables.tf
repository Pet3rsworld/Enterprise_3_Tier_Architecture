variable "project_name" {
  type        = string
  description = "Name of the project"
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet IDs for ALB"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subent IDs for the EC2 instances"
}

variable "alb_sg_id" {
  type        = string
  description = "Security Group ID for the ALB"
}

variable "ec2_sg_id" {
  type        = string
  description = "Security Group ID for the EC2 instances"
}

variable "rds_endpoint" {
  type        = string
  description = "Database connection string to pass to the web servers"
}
