# 1. Module for Backend
module "backend" {
  source       = "./modules/backend"
  project_name = "Enterprise_3_Tier_Architecture"
}

# 2. Module for Networking
module "networking" {
  source             = "./modules/networking"
  project_name       = "Enterprise_3_Tier_Architecture"
  vpc_cidr           = "10.0.0.0/16"
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets    = ["10.0.3.0/24", "10.0.4.0/24"]
  availability_zones = ["us-east-1a", "us-east-1b"]
}

# 3 Module for Security
module "security" {
  source       = "./modules/security"
  project_name = "Enterprise_3_Tier_Architecture"
  vpc_id       = module.networking.vpc_id
}

# Module for Database
module "database" {
  source             = "./modules/database"
  project_name       = "Enterprise_3_Tier_Architecture"
  private_subnet_ids = module.networking.private_subnet_ids
  rds_sg_id          = module.security.rds_sg_id
  rds_password       = var.rds_password
}

# Module for Compute
module "compute" {
  source             = "./modules/compute"
  project_name       = "Enterprise_3_Tier_Architecture"
  vpc_id             = module.networking.vpc_id
  public_subnet_ids  = module.networking.public_subnets_ids
  private_subnet_ids = module.networking.private_subnet_ids
  alb_sg_id          = module.security.alb_sg_id
  ec2_sg_id          = module.security.ec2_sg_id
  rds_endpoint       = module.database.rds_endpoint
}
