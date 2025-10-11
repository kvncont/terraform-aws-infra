output "lambda_function_name" {
  description = "Nombre de la función Lambda"
  value       = aws_lambda_function.main.function_name
}

output "lambda_function_arn" {
  description = "ARN de la función Lambda"
  value       = aws_lambda_function.main.arn
}

output "lambda_function_invoke_arn" {
  description = "ARN de invocación de la función Lambda"
  value       = aws_lambda_function.main.invoke_arn
}

output "lambda_execution_role_arn" {
  description = "ARN del rol de ejecución de la Lambda"
  value       = aws_iam_role.lambda_execution_role.arn
}

output "lambda_log_group_name" {
  description = "Nombre del grupo de logs de CloudWatch"
  value       = aws_cloudwatch_log_group.lambda_logs.name
}

output "lambda_last_modified" {
  description = "Última fecha de modificación de la Lambda"
  value       = aws_lambda_function.main.last_modified
}