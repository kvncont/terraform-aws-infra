# terraform-aws-infra

Repositorio de infraestructura de Terraform para AWS con workflows reutilizables de GitHub Actions.

## 🚀 Características

- **Workflows Reutilizables**: Workflows de GitHub Actions que pueden ser utilizados en múltiples repositorios
- **Terraform para AWS Lambda**: Infraestructura como código para desplegar funciones Lambda
- **Integración con ServiceNow**: Soporte opcional para ServiceNow DevOps
- **CI/CD Automatizado**: Pipeline completo de Terraform plan y apply

## 📋 Contenido

### Infraestructura Lambda

El directorio `lambdas/` contiene la infraestructura de Terraform para desplegar funciones Lambda en AWS.

📖 [Ver documentación de Lambdas](lambdas/.md)

### Workflows Reutilizables

Los workflows de GitHub Actions están diseñados para ser reutilizables en múltiples repositorios.

#### Workflow de Despliegue Terraform

Workflow completo para ejecutar Terraform plan y apply con soporte para múltiples entornos.

**Uso Rápido:**

```yaml
jobs:
  deploy:
    uses: kvncont/terraform-aws-infra/.github/workflows/terraform-deploy-reusable.yml@main
    with:
      aws-region: 'us-east-1'
      working-directory: 'terraform'
      tfvars-file: 'production.tfvars'
      environment: 'production'
    secrets:
      aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
      aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
```

📖 [Ver documentación completa de workflows](.github/workflows/README.md)

📝 [Ver ejemplo de uso](.github/workflows/USAGE_EXAMPLE.yml)

## 🔧 Requisitos

- Terraform >= 1.0
- AWS CLI configurado
- GitHub Actions
- Credenciales de AWS configuradas como secrets en GitHub

## 📦 Inputs del Workflow Reutilizable

| Input | Requerido | Default | Descripción |
|-------|-----------|---------|-------------|
| `terraform-version` | No | `1.5.0` | Versión de Terraform |
| `aws-region` | Sí | - | Región de AWS |
| `working-directory` | Sí | - | Directorio de Terraform |
| `tfvars-file` | Sí | - | Archivo de variables |
| `environment` | Sí | - | Nombre del entorno |
| `enable-servicenow` | No | `false` | Habilitar ServiceNow |
| `run-apply` | No | `true` | Ejecutar apply |

[Ver lista completa de inputs y secrets](.github/workflows/README.md#inputs)

## 🔐 Secrets Requeridos

Los siguientes secrets deben configurarse en tu repositorio:

- `AWS_ACCESS_KEY_ID` - AWS Access Key ID
- `AWS_SECRET_ACCESS_KEY` - AWS Secret Access Key
- `AWS_ROLE_TO_ASSUME` - (Opcional) IAM Role ARN

Para ServiceNow (opcional):
- `SN_DEVOPS_INTEGRATION_TOKEN`
- `SN_INSTANCE_URL`
- `SN_ORCHESTRATION_TOOL_ID`

## 📚 Documentación Adicional

- [Documentación de Workflows](.github/workflows/README.md) - Guía completa de workflows
- [Ejemplo de Uso](.github/workflows/USAGE_EXAMPLE.yml) - Template listo para copiar
- [Documentación de Lambdas](lambdas/.md) - Guía de infraestructura Lambda

## 🤝 Contribuir

Las contribuciones son bienvenidas. Por favor abre un issue o pull request para sugerencias.

## 📄 Licencia

Este proyecto está bajo la licencia correspondiente a tu organización.
