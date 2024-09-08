variable "s3_bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table"
  type        = string
}

variable "sns_topic_arn" {
  description = "ARN of the SNS topic"
  type        = string
}

variable "sqs_png_arn" {
  description = "ARN of the PNG SQS queue"
  type        = string
}

variable "sqs_jpg_arn" {
  description = "ARN of the JPG SQS queue"
  type        = string
}

variable "sqs_webp_arn" {
  description = "ARN of the WEBP SQS queue"
  type        = string
}

variable "azure_storage_connection_string" {
  description = "Azure Storage connection string"
  type        = string
}

variable "azure_container_name" {
  description = "The name of the blob container in Azure"
  type        = string
}