output "command_output" {
  value = module.cognito.command_output
}

output "api_gateway_endpoint" {
  value = module.api_gateway.aws_api_gateway_deployment_stag
}