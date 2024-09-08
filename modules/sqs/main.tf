resource "aws_sqs_queue" "sqs_png" {
  name = var.sqs_png_queue
}

resource "aws_sqs_queue" "sqs_jpg" {
  name = var.sqs_jpg_queue
}

resource "aws_sqs_queue" "sqs_webp" {
  name = var.sqs_webp_queue
}

resource "aws_sqs_queue_policy" "sqs_png_policy" {
  queue_url = aws_sqs_queue.sqs_png.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action    = "sqs:SendMessage",
        Resource  = aws_sqs_queue.sqs_png.arn
      }
    ]
  })
}

resource "aws_sqs_queue_policy" "sqs_jpg_policy" {
  queue_url = aws_sqs_queue.sqs_jpg.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action    = "sqs:SendMessage",
        Resource  = aws_sqs_queue.sqs_jpg.arn,
      }
    ]
  })
}

resource "aws_sqs_queue_policy" "sqs_webp_policy" {
  queue_url = aws_sqs_queue.sqs_webp.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action    = "sqs:SendMessage",
        Resource  = aws_sqs_queue.sqs_webp.arn,
      }
    ]
  })
}

resource "aws_lambda_permission" "sqs_png" {
  statement_id  = "AllowSQSInvokePNG"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_png_arn
  principal     = "sqs.amazonaws.com"
  source_arn    = aws_sqs_queue.sqs_png.arn
}

resource "aws_lambda_permission" "sqs_jpg" {
  statement_id  = "AllowSQSInvokeJPG"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_jpg_arn
  principal     = "sqs.amazonaws.com"
  source_arn    = aws_sqs_queue.sqs_jpg.arn
}

resource "aws_lambda_permission" "sqs_webp" {
  statement_id  = "AllowSQSInvokeWEBP"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_webp_arn
  principal     = "sqs.amazonaws.com"
  source_arn    = aws_sqs_queue.sqs_webp.arn
}