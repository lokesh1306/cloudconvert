resource "aws_sns_topic" "sns" {
  name = var.sns_topic_name
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.sns.arn
  protocol  = "email"
  endpoint  = var.email_endpoint
}


resource "aws_sns_topic_subscription" "png_subscription" {
  topic_arn = aws_sns_topic.sns.arn
  protocol  = "sqs"
  endpoint  = var.sqs_png_arn
}

resource "aws_sns_topic_subscription" "jpg_subscription" {
  topic_arn = aws_sns_topic.sns.arn
  protocol  = "sqs"
  endpoint  = var.sqs_jpg_arn
}

resource "aws_sns_topic_subscription" "webp_subscription" {
  topic_arn = aws_sns_topic.sns.arn
  protocol  = "sqs"
  endpoint  = var.sqs_webp_arn
}