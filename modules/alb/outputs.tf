output "alb_dns_name" {
  description = "DNS name of the ALB"
  value = aws_lb.main.dns_name
}

output "alb_zone_id" {
  description = "Route 53 hosted zone ID of the ALB"
  value = aws_lb.main.zone_id
}

output "alb_security_group_id" {
  description = "Security group ID of the ALB"
  value = aws_security_group.alb.id
}