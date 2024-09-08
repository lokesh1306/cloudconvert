import json
import boto3
import os
from uuid import uuid4
import base64

s3 = boto3.client('s3')
dynamodb = boto3.client('dynamodb')
sns = boto3.client('sns')

def lambda_handler(event, context):
    try:
        print("Event:", json.dumps(event))
        
        if event['isBase64Encoded']:
            image_data = base64.b64decode(event['body'])
        else:
            image_data = event['body'].encode('latin1')  
        
        print(f"Type of image_data: {type(image_data)}, Length of image_data: {len(image_data)}")
        
        image_id = str(uuid4())
        content_type = event['headers']['Content-Type']
        
        print(f"Content type: {content_type}")
        
        # Get file extension
        if content_type == 'image/png':
            extension = 'png'
        elif content_type == 'image/jpeg':
            extension = 'jpg'
        elif content_type == 'image/webp':
            extension = 'webp'
        else:
            raise ValueError("Unsupported image format")
        
        # S3 Key
        s3_key = f"{image_id}.{extension}"
        print(f"S3 key: {s3_key}")
        
        # Upload to S3
        s3.put_object(Bucket=os.environ['S3_BUCKET_NAME'], Key=s3_key, Body=image_data, ContentType=content_type)
        print(f"Uploaded to S3: {s3_key}")
        
        # update ddb
        dynamodb.put_item(
            TableName=os.environ['DYNAMODB_TABLE_NAME'],
            Item={
                'image_id': {'S': image_id},
                's3_key': {'S': s3_key},
                'status': {'S': 'uploaded'}
            }
        )
        print(f"Updated DynamoDB with ID: {image_id}")
        
        # SNS
        sns.publish(
            TopicArn=os.environ['SNS_TOPIC_ARN'],
            Message=json.dumps({'image_id': image_id, 's3_key': s3_key, 'azure_jpg_key': 'jpg/'+s3_key+'.jpg', 'azure_png_key': 'png/'+s3_key+'.png', 'azure_webp_key': 'webp/'+s3_key+'.webp'})
        )
        print(f"Message sent to SNS, ID: {image_id}")
        
        return {
            'statusCode': 200,
            'body': json.dumps({'message': 'Upload successful', 'image_id': image_id})
        }
    except Exception as e:
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
