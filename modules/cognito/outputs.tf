output "user_pool_id" {
  value = aws_cognito_user_pool.user_pool.arn
}

output "user_pool_client_id" {
  value = aws_cognito_user_pool_client.user_pool_client.id
}

output "authorizer_role_arn" {
  value = aws_iam_role.api_gateway_authorizer_role.arn
}

output "cognito_domain" {
  value = aws_cognito_user_pool_domain.user_pool_domain.domain
}

output "command_output" {
  value = data.local_file.creds.content
}