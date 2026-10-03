provider "aws" {
  region = var.aws_region
}

# -------------------------
# VPC Module
# -------------------------

module "vpc" {
  source = "./modules/vpc"

  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
}

# -------------------------
# EC2 Module
# -------------------------

module "ec2" {
  source = "./modules/ec2"

  # Take VPC ID from VPC module
  vpc_id = module.vpc.vpc_id

  # Put EC2 in the public subnet
  subnet_id = module.vpc.public_subnet_id

  # EC2 configuration
  ami_id        = var.ami_id
  instance_type = var.instance_type
}

#--------------------
#RDS
#--------------------
module "rds" {
  source = "./modules/rds"

  vpc_id                = module.vpc.vpc_id
  private_subnet_id     = module.vpc.private_subnet_id
  ec2_security_group_id = module.ec2.security_group_id
}