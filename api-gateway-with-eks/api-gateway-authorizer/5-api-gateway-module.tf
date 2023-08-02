module "apigateway-v2" {
  source  = "terraform-aws-modules/apigateway-v2/aws"
  version = "2.2.2"
  name    = "dev-api-gateway"
  #   The API protocol. Valid values: HTTP, WEBSOCKET
  protocol_type          = "HTTP"
  create_default_stage   = true
  create_api_domain_name = false
  default_route_settings = {
    detailed_metrics_enabled = true
    throttling_burst_limit   = 100
    throttling_rate_limit    = 100
  }
  integrations = {
    "GET /" = {
      lambda_arn             = module.lambda_function.lambda_function_arn
      payload_format_version = "2.0"
      timeout_milliseconds   = 12000
    }
    "GET /jwt-authorizer" = {
      lambda_arn               = module.lambda_function.lambda_function_arn
      payload_format_version   = "2.0"
      authorization_type       = "JWT"
      authorizer_key           = "jwt-authorizer"
      throttling_rate_limit    = 80
      throttling_burst_limit   = 40
      detailed_metrics_enabled = true
    }
    "GET /lambda-authorizer" = {
      lambda_arn             = module.lambda_function.lambda_function_arn
      payload_format_version = "2.0"
      authorization_type     = "CUSTOM"
      authorizer_key         = "lambda-authorizer"
      integration_uri        = module.lambda_authorizer.lambda_function_invoke_arn
      integration_type       = "AWS_PROXY"
      description            = "lambda-authorizer"
    }
  }
  authorizers = {
    "jwt-authorizer" = {
      authorizer_type                   = "JWT"
      identity_sources                  = "$request.header.Authorization"
      name                              = "jwt-authorizer"
      authorizer_uri                    = null
      audience                          = [aws_cognito_user_pool_client.client.id]
      issuer                            = "https://${aws_cognito_user_pool.jwt-user-pool.endpoint}"
      authorizer_payload_format_version = null
    }
    "lambda-authorizer" = {
      authorizer_type                   = "REQUEST"
      identity_sources                  = "$request.header.Authorization"
      name                              = "lambda-authorizer"
      authorizer_uri                    = module.lambda_authorizer.lambda_function_invoke_arn
      audience                          = []
      issuer                            = null
      authorizer_payload_format_version = "2.0"
    }
  }

}

