resource "random_id" "dynamodb" {
  byte_length = 8
  prefix      = "api"
}

resource "aws_dynamodb_table" "dynamodb" {
  name         = random_id.dynamodb.hex
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "image_id"
  attribute {
    name = "image_id"
    type = "S"
  }

  global_secondary_index {
    name            = "S3UploadIndex"
    hash_key        = "image_id"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "AzurePNGUploadIndex"
    hash_key        = "image_id"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "AzureJPGUploadIndex"
    hash_key        = "image_id"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "AzureWEBPUploadIndex"
    hash_key        = "image_id"
    projection_type = "ALL"
  }
}