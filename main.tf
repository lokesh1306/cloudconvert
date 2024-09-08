provider "aws" {
  region  = var.aws_region
  profile = var.profile
}

provider "azurerm" {
  features {}
}

module "s3_bucket" {
  source = "./modules/s3"
}

module "dynamodb" {
  source = "./modules/dynamodb"
}

module "sns" {
  source         = "./modules/sns"
  email_endpoint = var.email_endpoint
  sqs_png_arn    = module.sqs.sqs_png_arn
  sqs_jpg_arn    = module.sqs.sqs_jpg_arn
  sqs_webp_arn   = module.sqs.sqs_webp_arn
}

module "sqs" {
  source                   = "./modules/sqs"
  sns_topic_arn            = module.sns.sns_topic_arn
  lambda_function_png_arn  = module.lambda.lambda_function_png_arn
  lambda_function_jpg_arn  = module.lambda.lambda_function_jpg_arn
  lambda_function_webp_arn = module.lambda.lambda_function_webp_arn
}

module "azure_blob" {
  source = "./modules/azure_blob"
}

module "lambda" {
  source                          = "./modules/lambda"
  s3_bucket_name                  = module.s3_bucket.bucket_name
  dynamodb_table_name             = module.dynamodb.table_name
  sns_topic_arn                   = module.sns.sns_topic_arn
  sqs_png_arn                     = module.sqs.sqs_png_arn
  sqs_jpg_arn                     = module.sqs.sqs_jpg_arn
  sqs_webp_arn                    = module.sqs.sqs_webp_arn
  azure_storage_connection_string = module.azure_blob.storage_account_primary_connection_string
  azure_container_name            = module.azure_blob.container_name
}

module "api_gateway" {
  source                 = "./modules/api_gateway"
  lambda_function_arn    = module.lambda.lambda_function_arn
  authorizer_credentials = module.cognito.authorizer_role_arn
  cognito_user_pool_arn  = module.cognito.user_pool_id
}

module "cognito" {
  source = "./modules/cognito"
}