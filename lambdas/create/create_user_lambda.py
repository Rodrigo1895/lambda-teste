import os
import boto3
import json

def lambda_handler(event, context):

    request_body = event["body"]
    request_data = json.loads(request_body)

    # Dados do usuário a serem inseridos
    user_pool_id = os.environ["COGNITO_USER_POOL_ID"]
    client_id = os.environ["COGNITO_CLIENT_ID"]
    username = request_data['cpf']
    password = request_data['password']
    email = request_data['email']
    
    # Configuração do cliente Cognito
    client = boto3.client('cognito-idp')
    
    # Inserção do usuário no Cognito
    try:
        client.sign_up(
            ClientId=client_id,
            Username=username,
            Password=password,
            UserAttributes=[
                {'Name': 'email', 'Value': email}
                # Aqui você pode adicionar mais atributos, se necessário
            ]
        )

        client.admin_confirm_sign_up(
            UserPoolId=user_pool_id,
            Username=username
        )

        return {
            'statusCode': 200,
            'body': json.dumps({'message': 'Usuario inserido com sucesso!'})
        }
    except client.exceptions.UsernameExistsException as e:
        return {
            'statusCode': 400,
            'body': json.dumps({'error': 'O usuario ja existe'})
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }