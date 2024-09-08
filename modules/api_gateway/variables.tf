variable "lambda_function_arn" {
  description = "ARN of the Lambda function"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "authorizer_name" {
  description = "Name of the Cognito authorizer"
  type        = string
  default     = "cup"
}

variable "authorizer_credentials" {
  description = "Credentials for the authorizer"
  type        = string
  default     = "arn:aws:iam::123456789012:role/authorizer_role"
}

variable "cognito_user_pool_arn" {
  description = "ARN of the CUP"
  type        = string
}

variable "apigw_path" {
  description = "API Gateway Path"
  type        = string
  default     = "upload"
}