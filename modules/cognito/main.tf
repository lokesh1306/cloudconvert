data "aws_caller_identity" "current" {}

resource "random_id" "user_pool_name" {
  byte_length = 8
  prefix      = "api"
}

resource "random_id" "user_pool_client_name" {
  byte_length = 8
  prefix      = "api"
}

resource "random_string" "default_password" {
  length  = 12
  special = false
  lower   = true
  numeric = true
}

resource "random_id" "cognito_domain" {
  byte_length = 8
  prefix      = "api"
}

resource "aws_cognito_user_pool" "user_pool" {
  name = random_id.user_pool_name.hex

  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = false
    require_symbols   = false
    require_uppercase = true
  }

  auto_verified_attributes = ["email"]
}

resource "aws_cognito_user_pool_domain" "user_pool_domain" {
  domain       = random_id.cognito_domain.hex
  user_pool_id = aws_cognito_user_pool.user_pool.id
}

resource "aws_cognito_user_pool_client" "user_pool_client" {
  name         = random_id.user_pool_client_name.hex
  user_pool_id = aws_cognito_user_pool.user_pool.id

  explicit_auth_flows = ["ALLOW_USER_PASSWORD_AUTH", "ALLOW_REFRESH_TOKEN_AUTH", "ALLOW_CUSTOM_AUTH"]

  allowed_oauth_flows                  = ["implicit"]
  allowed_oauth_scopes                 = ["email", "openid", "profile", "phone"]
  allowed_oauth_flows_user_pool_client = true
  supported_identity_providers         = ["COGNITO"]
  callback_urls = [
    "https://${aws_cognito_user_pool_domain.user_pool_domain.domain}.auth.${var.region}.amazoncognito.com/oauth2/idpresponse"
  ]
  logout_urls = [
    "https://${aws_cognito_user_pool_domain.user_pool_domain.domain}.auth.${var.region}.amazoncognito.com/logout"
  ]
}

resource "aws_cognito_user" "default_user" {
  user_pool_id = aws_cognito_user_pool.user_pool.id
  username     = var.default_username
  attributes = {
    email = var.default_email
  }
  password = random_string.default_password.result
}

resource "aws_iam_role" "api_gateway_authorizer_role" {
  name = "api_gateway_authorizer_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "apigateway.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "api_gateway_authorizer_policy" {
  name = "api_gateway_authorizer_policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "lambda:InvokeFunction"
        Resource = "arn:aws:lambda:${var.region}:${data.aws_caller_identity.current.account_id}:function:my_lambda_function"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "api_gateway_authorizer_attachment" {
  role       = aws_iam_role.api_gateway_authorizer_role.name
  policy_arn = aws_iam_policy.api_gateway_authorizer_policy.arn
}

resource "null_resource" "token" {
  provisioner "local-exec" {
    command = <<EOT
      aws cognito-idp initiate-auth --auth-flow USER_PASSWORD_AUTH --client-id ${aws_cognito_user_pool_client.user_pool_client.id} --auth-parameters USERNAME=${var.default_username},PASSWORD=${random_string.default_password.result} --profile infra > ${path.module}/creds.txt
      cat ${path.module}/creds.txt | grep IdToken > ${path.module}/creds_new.txt
      sed -i '' 's/IdToken/Token/g' ${path.module}/creds_new.txt
      rm -rf ${path.module}/creds.txt
    EOT
  }
}

data "local_file" "creds" {
  filename   = "${path.module}/creds_new.txt"
  depends_on = [null_resource.token]
}