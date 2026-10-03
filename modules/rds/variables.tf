variable "aws_vpc"{
    description = "VPC id where RDS will be created"
    type = string
}

variable "private-subnet-id"{
    description = " private subnet_id for rds"
    type = string
}

variable "security_group_id"{
    description = "EC2 security group allowed to access RDS"
    type = string
}

variable "db_name" { 
    description = "Initial database name" 
    type = string default = "appdb" 
} 

variable "db_username" { 
    description = "Master username" 
    type = string 
    default = "admin" 
} 
#the password is sensitive and should not be casually displayed.
variable "db_password" { 
    description = "Master password" 
    type = string 
    sensitive = true 
} 

variable "db_instance_class" { 
    description = "RDS instance class" 
    type = string 
    default = "db.t3.micro" 
}