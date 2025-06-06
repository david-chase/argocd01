import boto3
import base64
import json
import logging
import os
from datetime import datetime

logger = logging.getLogger()
logger.setLevel(logging.INFO)

ecr_client = boto3.client('ecr')
secretsmanager_client = boto3.client('secretsmanager')

def lambda_handler(event, context):
    secret_arn = event["SecretId"]
    token = get_ecr_token()
    dockerconfig = make_dockerconfig(token)
    wrapped = {
        ".dockerconfigjson": json.dumps(dockerconfig)
    }
    secretsmanager_client.put_secret_value(
        SecretId=secret_arn,
        SecretString=json.dumps(wrapped)
    )
    logger.info("Successfully rotated secret for: %s", secret_arn)
    return

def get_ecr_token():
    response = ecr_client.get_authorization_token()
    auth_data = response['authorizationData'][0]
    token = base64.b64decode(auth_data['authorizationToken']).decode('utf-8')
    username, password = token.split(':')
    registry = auth_data['proxyEndpoint']
    return { "username": username, "password": password, "registry": registry }

def make_dockerconfig(token_info):
    auth = f"{token_info['username']}:{token_info['password']}"
    b64_auth = base64.b64encode(auth.encode('utf-8')).decode('utf-8')
    return {
        "auths": {
            token_info['registry']: {
                "username": token_info['username'],
                "password": token_info['password'],
                "auth": b64_auth
            }
        }
    }
