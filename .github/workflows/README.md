# GitHub Actions Workflows

Este directorio contiene los workflows de GitHub Actions para el repositorio.

## Workflows Disponibles

### 1. terraform-deploy-reusable.yml

**Workflow reutilizable** para desplegar infraestructura de Terraform en AWS.

#### Características

- ✅ Terraform plan y apply automático
- ✅ Comentarios en Pull Requests con el plan de Terraform
- ✅ Integración con ServiceNow DevOps (opcional)
- ✅ Validación y formateo de código Terraform
- ✅ Almacenamiento de artefactos del plan
- ✅ Configuración flexible de AWS credentials y región

#### Uso

Para usar este workflow reutilizable en tu repositorio, crea un archivo de workflow que lo llame:

```yaml
name: Deploy Infrastructure

on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main

jobs:
  deploy:
    uses: kvncont/terraform-aws-infra/.github/workflows/terraform-deploy-reusable.yml@main
    with:
      terraform-version: '1.5.0'
      aws-region: 'us-east-1'
      working-directory: 'path/to/terraform'
      tfvars-file: 'env/prod/prod.tfvars'
      environment: 'prod'
      enable-servicenow: false
      artifact-retention-days: 7
      run-apply: true
    secrets:
      aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
      aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
      aws-role-to-assume: ${{ secrets.AWS_ROLE_TO_ASSUME }}
```

#### Inputs

| Input | Descripción | Requerido | Default | Tipo |
|-------|-------------|-----------|---------|------|
| `terraform-version` | Versión de Terraform a usar | No | `1.5.0` | string |
| `aws-region` | Región de AWS donde desplegar | Sí | - | string |
| `working-directory` | Directorio donde están los archivos de Terraform | Sí | - | string |
| `tfvars-file` | Path al archivo de variables (relativo al working-directory) | Sí | - | string |
| `environment` | Nombre del entorno (dev, staging, prod) | Sí | - | string |
| `enable-servicenow` | Habilitar integración con ServiceNow DevOps | No | `false` | boolean |
| `servicenow-change-model` | Nombre del modelo de cambio de ServiceNow | No | `DevOps` | string |
| `servicenow-deployment-gate` | Configuración del deployment gate (JSON string) | No | `''` | string |
| `artifact-retention-days` | Días para retener artefactos del plan | No | `7` | number |
| `run-apply` | Ejecutar terraform apply después del plan | No | `true` | boolean |

#### Secrets

| Secret | Descripción | Requerido |
|--------|-------------|-----------|
| `aws-access-key-id` | AWS Access Key ID | Sí |
| `aws-secret-access-key` | AWS Secret Access Key | Sí |
| `aws-role-to-assume` | IAM role de AWS para asumir (opcional) | No |
| `sn-devops-integration-token` | Token de integración de ServiceNow DevOps | No* |
| `sn-instance-url` | URL de la instancia de ServiceNow | No* |
| `sn-orchestration-tool-id` | ID de herramienta de orquestación de ServiceNow | No* |

\* Requerido si `enable-servicenow` es `true`

#### Permisos Requeridos

El workflow requiere los siguientes permisos:

```yaml
permissions:
  contents: read
  pull-requests: write
  id-token: write
```

#### Jobs del Workflow

1. **terraform-plan**: Ejecuta `terraform plan` y sube el plan como artefacto
   - Valida y formatea el código
   - Comenta en el PR con el plan (solo en PRs)
   - Integración con ServiceNow (si está habilitada)

2. **terraform-apply**: Ejecuta `terraform apply` con el plan generado
   - Solo se ejecuta en la rama `main`
   - Requiere aprobación del environment configurado
   - Descarga el plan del job anterior

3. **change-request-info**: Obtiene información del change request de ServiceNow
   - Solo se ejecuta si ServiceNow está habilitado
   - Se ejecuta siempre después de terraform-apply

### 2. lambdas-dev.yml

Workflow específico para desplegar las funciones Lambda al entorno de desarrollo.

Este workflow utiliza el workflow reutilizable `terraform-deploy-reusable.yml` con configuración específica para el entorno de desarrollo.

#### Triggers

- **push** a la rama `main` que modifique:
  - `lambda/**`
  - `lambdas/env/dev/**`
  - `.github/workflows/lambdas-dev.yml`

- **pull_request** a la rama `main` que modifique los mismos paths

- **workflow_dispatch**: Ejecución manual

## Ejemplos de Uso en Otros Repositorios

### Ejemplo 1: Despliegue Básico

```yaml
name: Deploy to Production

on:
  push:
    branches:
      - main

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

### Ejemplo 2: Múltiples Entornos

```yaml
name: Deploy Multi-Environment

on:
  push:
    branches:
      - main
      - staging
      - develop

jobs:
  determine-environment:
    runs-on: ubuntu-latest
    outputs:
      environment: ${{ steps.set-env.outputs.environment }}
      tfvars: ${{ steps.set-env.outputs.tfvars }}
    steps:
      - id: set-env
        run: |
          if [ "${{ github.ref }}" = "refs/heads/main" ]; then
            echo "environment=production" >> $GITHUB_OUTPUT
            echo "tfvars=env/prod/prod.tfvars" >> $GITHUB_OUTPUT
          elif [ "${{ github.ref }}" = "refs/heads/staging" ]; then
            echo "environment=staging" >> $GITHUB_OUTPUT
            echo "tfvars=env/staging/staging.tfvars" >> $GITHUB_OUTPUT
          else
            echo "environment=development" >> $GITHUB_OUTPUT
            echo "tfvars=env/dev/dev.tfvars" >> $GITHUB_OUTPUT
          fi

  deploy:
    needs: determine-environment
    uses: kvncont/terraform-aws-infra/.github/workflows/terraform-deploy-reusable.yml@main
    with:
      aws-region: 'us-east-1'
      working-directory: 'infrastructure'
      tfvars-file: ${{ needs.determine-environment.outputs.tfvars }}
      environment: ${{ needs.determine-environment.outputs.environment }}
    secrets:
      aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
      aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
```

### Ejemplo 3: Con ServiceNow DevOps

```yaml
name: Deploy with ServiceNow

on:
  push:
    branches:
      - main

jobs:
  deploy:
    uses: kvncont/terraform-aws-infra/.github/workflows/terraform-deploy-reusable.yml@main
    with:
      aws-region: 'us-west-2'
      working-directory: 'terraform'
      tfvars-file: 'production.tfvars'
      environment: 'production'
      enable-servicenow: true
      servicenow-change-model: 'Standard'
      servicenow-deployment-gate: '{"environment":"production","jobName":"Terraform Apply"}'
    secrets:
      aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
      aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
      sn-devops-integration-token: ${{ secrets.SN_DEVOPS_INTEGRATION_TOKEN }}
      sn-instance-url: ${{ secrets.SN_INSTANCE_URL }}
      sn-orchestration-tool-id: ${{ secrets.SN_ORCHESTRATION_TOOL_ID }}
```

### Ejemplo 4: Solo Plan (Sin Apply)

```yaml
name: Terraform Plan Only

on:
  pull_request:
    branches:
      - main

jobs:
  plan:
    uses: kvncont/terraform-aws-infra/.github/workflows/terraform-deploy-reusable.yml@main
    with:
      aws-region: 'eu-west-1'
      working-directory: 'terraform'
      tfvars-file: 'dev.tfvars'
      environment: 'development'
      run-apply: false
    secrets:
      aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
      aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
```

## Configuración de Secrets

Para usar estos workflows en tu repositorio, necesitas configurar los siguientes secrets:

### Secrets Requeridos

1. **AWS_ACCESS_KEY_ID**: Tu AWS Access Key ID
2. **AWS_SECRET_ACCESS_KEY**: Tu AWS Secret Access Key

### Secrets Opcionales

3. **AWS_ROLE_TO_ASSUME**: ARN del IAM role a asumir (recomendado para seguridad)
4. **SN_DEVOPS_INTEGRATION_TOKEN**: Token para ServiceNow DevOps
5. **SN_INSTANCE_URL**: URL de tu instancia de ServiceNow
6. **SN_ORCHESTRATION_TOOL_ID**: ID de la herramienta en ServiceNow

### Cómo Configurar Secrets

1. Ve a tu repositorio en GitHub
2. Click en **Settings** → **Secrets and variables** → **Actions**
3. Click en **New repository secret**
4. Agrega cada secret con su nombre y valor correspondiente

## Requisitos

- Terraform >= 1.0
- AWS CLI configurado con credenciales válidas
- Permisos para crear recursos Lambda, IAM y CloudWatch en AWS
- (Opcional) Cuenta de ServiceNow con DevOps configurado

## Soporte

Para preguntas o problemas, por favor abre un issue en el repositorio.
