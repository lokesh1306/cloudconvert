variable "email_endpoint" {
  description = "The email endpoint for SNS"
  type        = string
}

variable "sns_topic_name" {
  description = "SNS topic name"
  type        = string
  default     = "ImageUploadSNSTopic"
}

variable "sqs_jpg_arn" {
  description = "SQS JPG ARN"
  type        = string
}

variable "sqs_webp_arn" {
  description = "SQS Webp ARN"
  type        = string
}

variable "sqs_png_arn" {
  description = "SQS PNG ARN"
  type        = string
}

