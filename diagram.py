from diagrams import Diagram, Cluster, Edge
from diagrams.aws.network import APIGateway
from diagrams.aws.security import Cognito
from diagrams.aws.compute import Lambda
from diagrams.aws.storage import S3
from diagrams.aws.database import Dynamodb
from diagrams.aws.integration import SNS, SQS
from diagrams.aws.management import Cloudwatch
from diagrams.aws.engagement import SES
from diagrams.azure.storage import BlobStorage

with Diagram("Image Upload Service", show=False):
    api_gateway = APIGateway("API Gateway")
    cognito = Cognito("Cognito")
    lambda_upload = Lambda("ImageUploadFunction")
    s3 = S3("S3 Bucket")
    dynamodb = Dynamodb("DynamoDB")
    sns_topic = SNS("ImageUploadSNSTopic")
    email_notification = SES("Email Notification")
    cloudwatch_upload = Cloudwatch("ImageUploadFunction Logs")
    
    with Cluster("SQS Queues"):
        sqs_queue1 = SQS("JPGSQSQueue")
        sqs_queue2 = SQS("WEBPSQSQueue")
        sqs_queue3 = SQS("PNGSQSQueue")

    with Cluster("Processing Lambdas"):
        lambda_processor1 = Lambda("ConvertToJPGFunction")
        lambda_processor2 = Lambda("ConvertToWEBPFunction")
        lambda_processor3 = Lambda("ConvertToPNGFunction")
        cloudwatch_processor1 = Cloudwatch("ConvertToJPGFunction Logs")
        cloudwatch_processor2 = Cloudwatch("ConvertToWEBPFunction Logs")
        cloudwatch_processor3 = Cloudwatch("ConvertToPNGFunction Logs")
    
    azure_blob_storage = BlobStorage("Azure Blob Storage")

    api_gateway >> Edge(label="Authenticate") >> cognito
    
    cognito >> Edge(label="Invoke") >> lambda_upload
    lambda_upload >> Edge(label="Upload Image") >> s3
    lambda_upload >> Edge(label="Log Status") >> dynamodb
    lambda_upload >> Edge(label="Send S3 Key") >> sns_topic
    lambda_upload >> cloudwatch_upload

    sns_topic >> Edge(label="Fanout") >> [sqs_queue1, sqs_queue2, sqs_queue3]
    sns_topic >> Edge(label="Notify") >> email_notification
    
    sqs_queue1 >> lambda_processor1
    sqs_queue2 >> lambda_processor2
    sqs_queue3 >> lambda_processor3

    s3 >> Edge(label="Download Image") >> [lambda_processor1, lambda_processor2, lambda_processor3]
    [lambda_processor1, lambda_processor2, lambda_processor3] >> Edge(label="Convert & Store") >> azure_blob_storage
    [lambda_processor1, lambda_processor2, lambda_processor3] >> Edge(label="Update") >> dynamodb
    lambda_processor1 >> cloudwatch_processor1
    lambda_processor2 >> cloudwatch_processor2
    lambda_processor3 >> cloudwatch_processor3
