resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Sid    = "",
        Principal = {
          Service = "lambda.amazonaws.com",
        },
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_policy" "lambda_sns_policy" {
  name        = "lambda_sns_policy"
  description = "IAM policy for Lambda to access SQS"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "sns:*"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_sqs_policy" {
  name        = "lambda_sqs_policy"
  description = "IAM policy for Lambda to access SQS"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "sqs:*"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "s3_policy" {
  name        = "s3_policy"
  description = "IAM policy for Lambda to access SQS"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:*"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "dynamodb_policy" {
  name        = "dynamodb_policy"
  description = "IAM policy for Lambda to access SQS"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "dynamodb:*"
        ],
        Resource = "*"
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "lambda_sns_policy_attachment" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.lambda_sns_policy.arn
}


resource "aws_iam_role_policy_attachment" "lambda_s3_policy_attachment" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.s3_policy.arn
}

resource "aws_iam_role_policy_attachment" "lambda_dynamodb_policy_attachment" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.dynamodb_policy.arn
}

resource "aws_iam_role_policy_attachment" "lambda_sqs_policy_attachment" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.lambda_sqs_policy.arn
}

resource "aws_lambda_layer_version" "pillow_layer" {
  filename                 = "${path.module}/code/pillow_layer.zip"
  layer_name               = "pillow_layer"
  compatible_runtimes      = ["python3.11"]
  compatible_architectures = ["arm64"]
}

resource "aws_lambda_layer_version" "azure_layer" {
  filename                 = "${path.module}/code/azure_layer.zip"
  layer_name               = "azure_layer"
  compatible_runtimes      = ["python3.11"]
  compatible_architectures = ["arm64"]
}

resource "aws_lambda_function" "image_upload_lambda" {
  filename      = "${path.module}/code/lambda_function.zip"
  function_name = "ImageUploadFunction"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.11"
  architectures = ["arm64"]
  environment {
    variables = {
      S3_BUCKET_NAME                  = var.s3_bucket_name
      DYNAMODB_TABLE_NAME             = var.dynamodb_table_name
      SNS_TOPIC_ARN                   = var.sns_topic_arn
      AZURE_STORAGE_CONNECTION_STRING = var.azure_storage_connection_string
      AZURE_CONTAINER_NAME            = var.azure_container_name
    }
  }
}

resource "aws_lambda_function" "convert_to_jpg" {
  filename      = "${path.module}/code/convert_to_jpg.zip"
  function_name = "ConvertToJPGFunction"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "convert_to_jpg.lambda_handler"
  runtime       = "python3.11"
  architectures = ["arm64"]
  timeout       = 30
  layers        = [aws_lambda_layer_version.azure_layer.arn, aws_lambda_layer_version.pillow_layer.arn]
  environment {
    variables = {
      DYNAMODB_TABLE_NAME             = var.dynamodb_table_name
      AZURE_STORAGE_CONNECTION_STRING = var.azure_storage_connection_string
      AZURE_CONTAINER_NAME            = var.azure_container_name
      S3_BUCKET_NAME                  = var.s3_bucket_name
    }
  }
}

resource "aws_lambda_function" "convert_to_webp" {
  filename      = "${path.module}/code/convert_to_webp.zip"
  function_name = "ConvertToWEBPFunction"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "convert_to_webp.lambda_handler"
  runtime       = "python3.11"
  architectures = ["arm64"]
  timeout       = 30
  layers        = [aws_lambda_layer_version.azure_layer.arn, aws_lambda_layer_version.pillow_layer.arn]
  environment {
    variables = {
      DYNAMODB_TABLE_NAME             = var.dynamodb_table_name
      AZURE_STORAGE_CONNECTION_STRING = var.azure_storage_connection_string
      AZURE_CONTAINER_NAME            = var.azure_container_name
      S3_BUCKET_NAME                  = var.s3_bucket_name
    }
  }
}

resource "aws_lambda_function" "convert_to_png" {
  filename      = "${path.module}/code/convert_to_png.zip"
  function_name = "ConvertToPNGFunction"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "convert_to_png.lambda_handler"
  runtime       = "python3.11"
  architectures = ["arm64"]
  timeout       = 30
  layers        = [aws_lambda_layer_version.azure_layer.arn, aws_lambda_layer_version.pillow_layer.arn]
  environment {
    variables = {
      DYNAMODB_TABLE_NAME             = var.dynamodb_table_name
      AZURE_STORAGE_CONNECTION_STRING = var.azure_storage_connection_string
      AZURE_CONTAINER_NAME            = var.azure_container_name
      S3_BUCKET_NAME                  = var.s3_bucket_name
    }
  }
}

resource "aws_lambda_event_source_mapping" "sqs_png" {
  event_source_arn = var.sqs_png_arn
  function_name    = aws_lambda_function.convert_to_png.arn
  enabled          = true
  batch_size       = 10
}

resource "aws_lambda_event_source_mapping" "sqs_jpg" {
  event_source_arn = var.sqs_jpg_arn
  function_name    = aws_lambda_function.convert_to_jpg.arn
  enabled          = true
  batch_size       = 10
}

resource "aws_lambda_event_source_mapping" "sqs_webp" {
  event_source_arn = var.sqs_webp_arn
  function_name    = aws_lambda_function.convert_to_webp.arn
  enabled          = true
  batch_size       = 10
}
