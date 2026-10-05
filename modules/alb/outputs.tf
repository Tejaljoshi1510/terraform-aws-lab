output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value = module.alb.alb_dns_name
}

output "alb_zone_id" {
  description = "Route 53 hosted zone ID of the ALB"
  value = module.alb.alb_zone_id
}

output "alb_security_group_id" {
  description = "ALB security group ID"
  value = module.alb.alb_security_group_id
}