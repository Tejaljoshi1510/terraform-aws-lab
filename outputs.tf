output "vpc_id" { 
    description = "ID of the VPC" 
    value = module.vpc.vpc_id 
    } 
output "public_subnet_id" { 
    description = "ID of the public subnet"
    value = module.vpc.public_subnet_id 
    } 
output "private_subnet_id" { 
    description = "ID of the private subnet" 
    value = module.vpc.private_subnet_id 
    } 
    
output "ec2_instance_id" { 
    description = "ID of the EC2 instance" 
    value = module.ec2.instance_id 
    } 
    
output "ec2_public_ip" {
     description = "Public IP of the EC2 instance" 
     value = module.ec2.public_ip 
    } 
    
output "ec2_security_group_id" { 
    description = "Security group ID of the EC2 instance" 
    value = module.ec2.security_group_id 
}

#rds
output "rds_instance_id" { 
    description = "RDS instance ID" 
    value = module.rds.db_instance_id 
} 
output "rds_endpoint" { 
    description = "RDS endpoint" 
    value = module.rds.db_endpoint 
} 
output "rds_port" { 
    description = "RDS port" 
    value = module.rds.db_port 
} 
output "rds_security_group_id" { 
    description = "RDS security group ID" 
    value = module.rds.security_group_id 
}