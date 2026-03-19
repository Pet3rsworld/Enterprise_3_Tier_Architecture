output "vpc_id" {
  value       = aws_vpc.vpc_creation.id
  description = "ID of the VPC"
}

output "public_subnets_ids" {
  value       = aws_subnet.our_public_subnets[*].id
  description = "ID of the Public Subnet"
}

output "private_subnet_ids" {
  value       = aws_subnet.our_private_subnets[*].id
  description = "ID of the Private Subnet"
}
