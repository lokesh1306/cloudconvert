variable "email_endpoint" {
  description = "The email endpoint for SNS"
  type        = string
  default     = "chlokesh1306@gmail.com"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "profile" {
  description = "AWS CLI Profile Name"
  type        = string
  default     = "default"
}