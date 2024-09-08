variable "sns_topic_arn" {
  description = "The ARN of the SNS topic"
  type        = string
}

variable "lambda_function_png_arn" {
  description = "The ARN of the Lambda function"
  type        = string
}

variable "lambda_function_jpg_arn" {
  description = "The ARN of the Lambda function"
  type        = string
}

variable "lambda_function_webp_arn" {
  description = "The ARN of the Lambda function"
  type        = string
}

variable "sqs_webp_queue" {
  description = "Name of WEBP SQS Queue"
  type        = string
  default = "WEBPSQSQueue"
}

variable "sqs_png_queue" {
  description = "Name of PNG SQS Queue"
  type        = string
  default = "PNGSQSQueue"
}

variable "sqs_jpg_queue" {
  description = "Name of JPG SQS Queue"
  type        = string
  default = "JPGSQSQueue"
}