# GitHub Actions Workflows

## Deploy Lambda Infrastructure - Dev

Este workflow automatiza el despliegue de la infraestructura Lambda para el entorno de desarrollo usando Terraform y ServiceNow Change Velocity.

### Características

- **Triggers**: Se ejecuta en push o pull request a `main` cuando hay cambios en:
  - `lambda/**`
  - `lambdas/env/dev/**`

- **ServiceNow Integration**: Automatiza la creación y gestión de Change Requests
- **Terraform Operations**: Init, Format, Validate, Plan y Apply
- **Environment Protection**: El job de Apply usa el environment `dev` para protección adicional
- **PR Comments**: Comenta automáticamente en PRs con los resultados del plan

### Jobs

1. **servicenow-change-create**: Crea un Change Request en ServiceNow
2. **terraform-plan**: Ejecuta Terraform plan y valida el código
3. **terraform-apply**: Aplica los cambios (solo en push a main, requiere aprobación del environment)

### Secrets Requeridos

Configura los siguientes secrets en GitHub:

#### AWS Credentials
- `AWS_ROLE_TO_ASSUME`: ARN del rol de AWS para asumir (usando OIDC)

#### ServiceNow
- `SN_INSTANCE_URL`: URL de tu instancia de ServiceNow (ej: https://dev12345.service-now.com)
- `SN_USERNAME`: Usuario de ServiceNow con permisos para crear change requests
- `SN_PASSWORD`: Contraseña del usuario de ServiceNow
- `SN_ASSIGNMENT_GROUP`: Grupo de asignación para los change requests

### Environment

Crea un environment llamado `dev` en GitHub con las siguientes configuraciones:
- **Reviewers**: Usuarios o equipos que deben aprobar antes del deploy
- **Wait timer**: Opcional, tiempo de espera antes de deploy
- **Deployment branches**: Configura para permitir solo `main`

### Configuración AWS OIDC

Para usar AWS credentials con OIDC, configura un Identity Provider en AWS:

1. Crea un Identity Provider en AWS IAM para GitHub Actions
2. Crea un rol con la política de confianza apropiada
3. Asigna permisos necesarios para crear recursos Lambda, IAM y CloudWatch
4. Agrega el ARN del rol al secret `AWS_ROLE_TO_ASSUME`

### Variables de Entorno del Workflow

- `TF_VERSION`: Versión de Terraform (default: 1.5.0)
- `AWS_REGION`: Región de AWS (default: us-east-1)
- `WORKING_DIR`: Directorio de trabajo (default: lambdas)
- `TF_VAR_FILE`: Archivo de variables de Terraform (default: env/dev/dev.tfvars)

### Flujo de Trabajo

#### Para Pull Requests:
1. Se crea un Change Request en ServiceNow
2. Se ejecuta Terraform plan
3. Los resultados se comentan en el PR
4. Se actualiza el Change Request con los resultados

#### Para Push a Main:
1. Se crea un Change Request en ServiceNow
2. Se ejecuta Terraform plan
3. **Requiere aprobación manual del environment `dev`**
4. Se ejecuta Terraform apply
5. Se actualiza y cierra el Change Request basado en el resultado

### Personalización

Para modificar el workflow:
- Ajusta los path filters según tus necesidades
- Modifica las variables de entorno
- Personaliza los parámetros de ServiceNow Change Request
- Ajusta los permisos y configuración del environment
