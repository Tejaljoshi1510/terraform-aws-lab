# RDS Security Group 
resource "aws_security_group" "rds" {
  name        = "terraform-rds-sg"
  description = "Security group for RDS PostgreSQL"
  vpc_id      = var.vpc_id

  tags = {
    Name = "rds-sg"
  }
}

# Allow PostgreSQL 
# from EC2 Security Group 

resource "aws_vpc_security_group_ingress_rule" "postgres" {
  security_group_id = aws_security_group.rds.id

  referenced_security_group_id = var.ec2_security_group_id

  from_port   = 5432
  to_port     = 5432
  ip_protocol = "tcp"
}

# RDS Egress 

resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.rds.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

# DB Subnet Group 

resource "aws_db_subnet_group" "main" {
  name = "terraform-db-subnet-group"

  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "terraform-db-subnet-group"
  }
}


# PostgreSQL RDS 

resource "aws_db_instance" "postgres" {
  identifier = "terraform-postgres"

  engine = "postgres"

  instance_class    = var.db_instance_class
  allocated_storage = 20
  storage_type      = "gp3"

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name = aws_db_subnet_group.main.name

  vpc_security_group_ids = [
    aws_security_group.rds.id
  ]

  publicly_accessible = false

  skip_final_snapshot = true

  tags = {
    Name = "terraform-postgres"
  }
}