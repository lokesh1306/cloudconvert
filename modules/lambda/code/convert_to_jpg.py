import boto3
import os
from PIL import Image
import io
import json
import logging
from azure.storage.blob import BlobServiceClient

# logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

dynamodb = boto3.client('dynamodb')
s3 = boto3.client('s3')

def lambda_handler(event, context):
    logger.info("Event: %s", json.dumps(event))
    
    for record in event['Records']:
        try:
            message_body = record['body']
            logger.info("Message body: %s", message_body)
            
            sns_message = json.loads(message_body)
            logger.info("SNS message: %s", json.dumps(sns_message))
            
            actual_message = json.loads(sns_message['Message'])
            logger.info("Actual message: %s", json.dumps(actual_message))
            
            image_id = actual_message['image_id']
            s3_key = actual_message['s3_key']
            
            # s3 image fetch
            s3_response = s3.get_object(Bucket=os.environ['S3_BUCKET_NAME'], Key=s3_key)
            image_data = s3_response['Body'].read()
            logger.info("S3 key: %s", s3_key)
            
            # content type and convert
            image = Image.open(io.BytesIO(image_data))
            if image.format == 'JPEG':
                logger.info("Image is already in JPG")
                jpg_data = image_data
            else:
                with io.BytesIO() as output:
                    image.convert('RGB').save(output, format='JPEG')
                    jpg_data = output.getvalue()
                logger.info("Converted to JPG")
            
            # azure upload
            blob_service_client = BlobServiceClient.from_connection_string(os.environ['AZURE_STORAGE_CONNECTION_STRING'])
            blob_client = blob_service_client.get_blob_client(container=os.environ['AZURE_CONTAINER_NAME'], blob=f'jpg/{image_id}.jpg')
            blob_client.upload_blob(jpg_data, overwrite=True)
            logger.info("Uploaded to blob")
            
            # update ddb
            dynamodb.update_item(
                TableName=os.environ['DYNAMODB_TABLE_NAME'],
                Key={'image_id': {'S': image_id}},
                UpdateExpression="SET azure_jpg_key = :jpg",
                ExpressionAttributeValues={':jpg': {'S': 'jpg/'+image_id+'.jpg'}}
            )
            logger.info("Updated DynamoDB: %s", image_id)
        
        except KeyError as e:
            logger.error("Missing key %s message body: %s", e, message_body)
            raise e
        except Exception as e:
            logger.error("Error processing: %s", e)
            raise e
