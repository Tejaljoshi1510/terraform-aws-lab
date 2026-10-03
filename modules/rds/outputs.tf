output "db_instance_id" { 
    description = "RDS instance ID" 
    value = aws_db_instance.postgres.id 
} 
output "db_endpoint" { 
    description = "RDS PostgreSQL endpoint" 
    value = aws_db_instance.postgres.address 
} 
output "db_port" { 
    description = "RDS PostgreSQL port" 
    value = aws_db_instance.postgres.port 
}
output "security_group_id" { 
    description = "RDS security group ID" 
    value = aws_security_group.rds.id 
}