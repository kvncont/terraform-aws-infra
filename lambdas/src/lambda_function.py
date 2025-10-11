import json
import logging
import os

# Configurar logging
logger = logging.getLogger()
log_level = os.environ.get('LOG_LEVEL', 'INFO')
logger.setLevel(getattr(logging, log_level))

def lambda_handler(event, context):
    """
    Función Lambda principal
    
    Args:
        event: Evento que activa la Lambda
        context: Contexto de ejecución de Lambda
        
    Returns:
        dict: Respuesta HTTP
    """
    logger.info(f"Event received: {json.dumps(event, default=str)}")
    
    # Obtener variables de entorno
    environment = os.environ.get('ENVIRONMENT', 'unknown')
    app_name = os.environ.get('APP_NAME', 'lambda-app')
    
    try:
        # Lógica de tu aplicación aquí
        response_body = {
            'message': 'Hello from AWS Lambda!',
            'environment': environment,
            'app_name': app_name,
            'function_name': context.function_name,
            'request_id': context.aws_request_id,
            'event': event
        }
        
        logger.info(f"Response: {json.dumps(response_body, default=str)}")
        
        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
                'Access-Control-Allow-Headers': 'Content-Type, X-Amz-Date, Authorization, X-Api-Key, X-Amz-Security-Token'
            },
            'body': json.dumps(response_body)
        }
        
    except Exception as e:
        logger.error(f"Error processing request: {str(e)}")
        
        return {
            'statusCode': 500,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({
                'error': 'Internal Server Error',
                'message': str(e)
            })
        }