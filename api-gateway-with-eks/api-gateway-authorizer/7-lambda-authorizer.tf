
locals {
  package_url_py = "https://raw.githubusercontent.com/awslabs/aws-apigateway-lambda-authorizer-blueprints/master/blueprints/python/api-gateway-authorizer-python.py"
  downloaded_py  = "api-gateway-authorizer-python.py"
}

resource "null_resource" "download-package" {
  triggers = {
    downloaded_py = local.downloaded_py
  }

  provisioner "local-exec" {
    command = "curl -L -o ${local.downloaded_py} ${local.package_url_py}"
  }
}

data "archive_file" "lambda_authorizer" {
  type             = "zip"
  source_file      = local.downloaded_py
  output_file_mode = "0666"
  output_path      = "lambda_authorizer.py.zip"
  depends_on       = [null_resource.download-package]
}

module "lambda_authorizer" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "5.3.0"

  function_name = "dev-lambda-authorizer"
  description   = "My awesome lambda function"
  #   Function entrypoint in your code.
  handler = "api-gateway-authorizer-python.lambda_handler"
  runtime = "python3.8"

  publish = true

  create_package         = false
  local_existing_package = data.archive_file.lambda_authorizer.output_path

}