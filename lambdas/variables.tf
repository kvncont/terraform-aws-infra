# Variables de configuración general
variable "aws_region" {
  description = "Región de AWS donde se desplegarán los recursos"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Entorno de despliegue (dev, staging, prod)"
  type        = string
}

variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
}

# Variables de la Lambda
variable "lambda_function_name" {
  description = "Nombre de la función Lambda"
  type        = string
}

variable "lambda_runtime" {
  description = "Runtime de la función Lambda"
  type        = string
  default     = "python3.11"
}

variable "lambda_handler" {
  description = "Handler de la función Lambda"
  type        = string
  default     = "lambda_function.lambda_handler"
}

variable "lambda_timeout" {
  description = "Timeout de la función Lambda en segundos"
  type        = number
  default     = 30
}

variable "lambda_memory_size" {
  description = "Memoria asignada a la función Lambda en MB"
  type        = number
  default     = 128
}

variable "lambda_description" {
  description = "Descripción de la función Lambda"
  type        = string
  default     = "Lambda function deployed with Terraform"
}

# Variables del código fuente
variable "lambda_source_dir" {
  description = "Directorio del código fuente de la Lambda (relativo al módulo)"
  type        = string
  default     = "src"
}

variable "lambda_zip_file" {
  description = "Nombre del archivo ZIP que contendrá el código de la Lambda"
  type        = string
  default     = "lambda_function.zip"
}

# Variables de IAM
variable "lambda_execution_role_name" {
  description = "Nombre del rol de ejecución de la Lambda"
  type        = string
  default     = ""
}

# Variables de variables de entorno
variable "lambda_environment_variables" {
  description = "Variables de entorno para la función Lambda"
  type        = map(string)
  default     = {}
}