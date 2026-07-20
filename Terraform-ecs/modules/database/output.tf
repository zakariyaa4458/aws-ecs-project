output "db_host" {
  description = "Database endpoint address"
  value       = aws_db_instance.mydb.address
}

output "db_port" {
  description = "Database port"
  value       = aws_db_instance.mydb.port
}

output "db_name" {
  description = "Database name"
  value       = aws_db_instance.mydb.db_name
}

output "db_user" {
  description = "Database username"
  value       = aws_db_instance.mydb.username
}

output "db_password_parameter_arn" {
  description = "ARN of the SSM parameter containing the database password"
  value       = aws_ssm_parameter.db_password.arn
}