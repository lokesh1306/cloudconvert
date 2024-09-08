output "sqs_png_arn" {
  value = aws_sqs_queue.sqs_png.arn
}

output "sqs_jpg_arn" {
  value = aws_sqs_queue.sqs_jpg.arn
}

output "sqs_webp_arn" {
  value = aws_sqs_queue.sqs_webp.arn
}
