provider "aws" {
  region = var.aws_region
}

# -------------------------
# VPC Module
# -------------------------

module "vpc" {
  source = "./modules/vpc"

  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

# -------------------------
# EC2 Module
# -------------------------

module "ec2" {
  source = "./modules/ec2"

  vpc_id        = module.vpc.vpc_id
  subnet_id     = module.vpc.public_subnet_ids[0]
  ami_id        = var.ami_id
  instance_type = var.instance_type
}
#--------------------
#RDS
#--------------------
module "rds" {
  source = "./modules/rds"

  vpc_id = module.vpc.vpc_id

  private_subnet_ids = module.vpc.private_subnet_ids

  ec2_security_group_id = module.ec2.security_group_id

  db_name           = var.db_name
  db_username       = var.db_username
  db_password       = var.db_password
  db_instance_class = var.db_instance_class
}