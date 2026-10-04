variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = [
    "ap-south-1a",
    "ap-south-1b"
  ]
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs"
  type        = list(string)
  default     = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDRs"
  type        = list(string)
  default     = [
    "10.0.11.0/24",
    "10.0.12.0/24"
  ]
}

variable "ami_id" { 
  description = "AMI ID for EC2" 
  type = string 
  default = "ami-xxxxxxxxxxxxxxxxx"
}

variable "instance_type" { 
  description = "EC2 instance type" 
  type = string 
  default = "t3.micro" 
}

variable "db_name" { 
  description = "Initial database name" 
  type = string default = "appdb" 
} 

variable "db_username" { 
  description = "RDS master username" 
  type = string default = "admin" 
} 
variable "db_password" { 
  description = "RDS master password" 
  type = string 
  sensitive = true 
} 
variable "db_instance_class" { 
  description = "RDS instance class" 
  type = string 
  default = "db.t3.micro" 
}