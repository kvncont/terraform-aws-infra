# Configuración para el entorno de desarrollo

# Variables generales
aws_region   = "us-east-1"
environment  = "dev"
project_name = "terraform-aws-infra"

# Variables de la Lambda
lambda_function_name = "my-lambda-function-dev"
lambda_runtime       = "python3.11"
lambda_handler       = "lambda_function.lambda_handler"
lambda_timeout       = 30
lambda_memory_size   = 128
lambda_description   = "Lambda function for development environment"

# Directorio del código fuente (usa el valor por defecto de variables.tf)
lambda_zip_file   = "lambda_function_dev.zip"

# Rol de ejecución (opcional, se generará automáticamente si está vacío)
lambda_execution_role_name = ""

# Variables de entorno para la Lambda
lambda_environment_variables = {
  ENVIRONMENT = "dev"
  LOG_LEVEL   = "DEBUG"
  APP_NAME    = "my-lambda-app"
}