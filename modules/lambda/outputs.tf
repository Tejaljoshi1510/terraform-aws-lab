output "lambda_function_name" {
  description = "Lambda function name"
  value       = aws_lambda_function.rds_query.function_name
}

output "lambda_function_arn" {
  description = "Lambda function ARN"
  value       = aws_lambda_function.rds_query.arn
}

output "security_group_id" {
  description = "Lambda security group ID"
  value       = aws_security_group.lambda.id
}