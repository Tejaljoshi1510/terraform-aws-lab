output "record_name" {
  description = "Route 53 record name"
  value = aws_route53_record.app.name
}