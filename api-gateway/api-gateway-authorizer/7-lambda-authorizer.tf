
locals {
  lambda_authorizer_source = "api-gateway-authorizer-python.py"
  # lambda_authorizer_source = "api-gateway-authorizer.mjs"
}


data "archive_file" "lambda_authorizer" {
  type             = "zip"
  source_file      = local.lambda_authorizer_source
  output_file_mode = "0666"
  output_path      = "api-gateway-authorizer.py.zip"
}

module "lambda_authorizer" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "5.3.0"

  function_name = "dev-lambda-authorizer"
  description   = "Lambda authorizer"
  #   Function entrypoint in your code.
  # handler = "api-gateway-authorizer.handler"
  # runtime = "nodejs18.x"
  handler = "api-gateway-authorizer-python.lambda_handler"
  runtime = "python3.8"

  publish = true

  create_package         = false
  local_existing_package = data.archive_file.lambda_authorizer.output_path

}

locals {
  authorizer_id           = values({ for k, v in module.apigateway-v2.apigatewayv2_authorizer_id : k => v if k == "lambda-authorizer" })[0]
  apigw_lambda_source_arn = format("%s/authorizers/%s", module.apigateway-v2.apigatewayv2_api_execution_arn, local.authorizer_id)
}
resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_authorizer.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = local.apigw_lambda_source_arn
}

