provider "aws" {
  region = var.aws_region
}


# VPC Module


module "vpc" {
  source = "../../modules/vpc"

  vpc_cidr = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}


# EC2 Module


module "ec2" {
  source = "../../modules/ec2"

  vpc_id = module.vpc.vpc_id
  subnet_id = module.vpc.public_subnet_ids[0]
  ami_id = var.ami_id
  instance_type = var.instance_type
}

#RDS

module "rds" {
  source = "../../modules/rds"

  vpc_id = module.vpc.vpc_id

  private_subnet_ids = module.vpc.private_subnet_ids

  ec2_security_group_id = module.ec2.security_group_id

  db_name = var.db_name
  db_username = var.db_username
  db_password = var.db_password
  db_instance_class = var.db_instance_class
}


#lambda


module "lambda" {
  source = "../../modules/lambda"

  vpc_id = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids

  rds_endpoint = module.rds.db_endpoint

  db_name = var.db_name
  db_username = var.db_username
  db_password = var.db_password
}


#Allow Lambda → RDS


resource "aws_vpc_security_group_ingress_rule" "lambda_to_rds" {
  security_group_id = module.rds.security_group_id

  referenced_security_group_id = module.lambda.security_group_id

  from_port = 5432
  to_port  = 5432
  ip_protocol = "tcp"
}


#alb

module "alb" {
  source = "../../modules/alb"

  vpc_id = module.vpc.vpc_id

  public_subnet_ids = module.vpc.public_subnet_ids

  target_instance_id = module.ec2.instance_id
}


#allow alb-> EC2 rule

resource "aws_vpc_security_group_ingress_rule" "alb_to_ec2" {
  security_group_id = module.ec2.security_group_id

  referenced_security_group_id = module.alb.alb_security_group_id

  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
}


#aws_route53_record

module "route53" {
  source = "../../modules/route53"

  hosted_zone_id = var.hosted_zone_id
  record_name    = var.record_name

  alb_dns_name = module.alb.alb_dns_name
  alb_zone_id  = module.alb.alb_zone_id
}
