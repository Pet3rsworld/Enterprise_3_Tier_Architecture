# 1. Databse Subnet Group
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${lower(var.project_name)}-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}

# 2. RDS Databse Instance
resource "aws_db_instance" "rds_instance" {
  identifier           = "enterprise-3-tier-architecture-rds-instance"
  allocated_storage    = 20
  db_name              = "enterprisedb"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = "Pet3r"
  password             = var.rds_password
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
  skip_final_snapshot  = true
  publicly_accessible  = false

  tags = {
    Name = "${var.project_name}-rds-instance"
  }
}

