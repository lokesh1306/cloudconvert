output "lambda_function_arn" {
  value = aws_lambda_function.image_upload_lambda.arn
}

output "lambda_function_jpg_arn" {
  value = aws_lambda_function.convert_to_jpg.arn
}

output "lambda_function_png_arn" {
  value = aws_lambda_function.convert_to_png.arn
}

output "lambda_function_webp_arn" {
  value = aws_lambda_function.convert_to_webp.arn
}
