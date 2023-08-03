output "apigatewayv2_api_id" {
  description = "The API identifier"
  value       = module.apigateway-v2.apigatewayv2_api_id
}

output "apigatewayv2_api_api_endpoint" {
  description = "The URI of the API"
  value       = module.apigateway-v2.apigatewayv2_api_api_endpoint
}

output "apigatewayv2_api_arn" {
  description = "The ARN of the API"
  value       = module.apigateway-v2.apigatewayv2_api_arn
}

output "apigatewayv2_api_execution_arn" {
  description = "The ARN prefix to be used in an aws_lambda_permission's source_arn attribute or in an aws_iam_policy to authorize access to the @connections API."
  value       = module.apigateway-v2.apigatewayv2_api_execution_arn
}

# default stage
output "default_apigatewayv2_stage_id" {
  description = "The default stage identifier"
  value       = module.apigateway-v2.default_apigatewayv2_stage_id
}

output "default_apigatewayv2_stage_arn" {
  description = "The default stage ARN"
  value       = module.apigateway-v2.default_apigatewayv2_stage_arn
}

output "default_apigatewayv2_stage_execution_arn" {
  description = "The ARN prefix to be used in an aws_lambda_permission's source_arn attribute or in an aws_iam_policy to authorize access to the @connections API."
  value       = module.apigateway-v2.default_apigatewayv2_stage_execution_arn
}

output "default_apigatewayv2_stage_invoke_url" {
  description = "The URL to invoke the API pointing to the stage"
  value       = module.apigateway-v2.default_apigatewayv2_stage_invoke_url
}




# api mapping
# output "apigatewayv2_api_mapping_id" {
#   description = "The API mapping identifier."
#   value       = try(aws_apigatewayv2_api_mapping.this[0].id, "")
# }

# route
# output "apigatewayv2_route_id" {
#  description = "The default route identifier."
#  value       = try(aws_apigatewayv2_route.this[0].id, "")
# }
