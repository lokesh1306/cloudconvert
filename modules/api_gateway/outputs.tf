output "api_endpoint" {
  value = aws_api_gateway_rest_api.api.execution_arn
}

output "aws_api_gateway_deployment_stag" {
  value = "${aws_api_gateway_deployment.deployment.invoke_url}/${var.apigw_path}"
}