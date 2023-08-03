
locals {
  package_url = "https://raw.githubusercontent.com/terraform-aws-modules/terraform-aws-lambda/master/examples/fixtures/python3.8-zip/existing_package.zip"
  downloaded  = "lambda_app_${md5(local.package_url)}.zip"
}

resource "null_resource" "download_package" {
  triggers = {
    downloaded = local.downloaded
  }

  provisioner "local-exec" {
    command = "curl -L -o ${local.downloaded} ${local.package_url}"
  }
}

module "lambda_function" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "5.3.0"

  function_name = "dev-stage-lambda"
  description   = "My awesome lambda function"
  #   Function entrypoint in your code.
  handler = "index.lambda_handler"
  runtime = "python3.8"

  publish = true

  create_package         = false
  local_existing_package = local.downloaded

  allowed_triggers = {
    AllowExecutionFromAPIGateway = {
      # The principal who is getting this permission
      service    = "apigateway"
      source_arn = "${module.apigateway-v2.apigatewayv2_api_execution_arn}/*/*"
    }
  }
}