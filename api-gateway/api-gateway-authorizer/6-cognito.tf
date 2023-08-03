
# #create a user pool
# resource "aws_cognito_user_pool" "jwt-user-pool" {
#   name = "jwt-user-pool"
# }

# resource "aws_cognito_user_pool_client" "client" {
#   name                                 = "client"
#   user_pool_id                         = aws_cognito_user_pool.jwt-user-pool.id
#   callback_urls                        = ["http://localhost"]
#   allowed_oauth_flows_user_pool_client = true
#   # Select "code" grant to pass codes to your app that it can redeem for tokens with the Token endpoint.
#   # Select "implicit" grant to pass ID and access tokens directly to your app. The implicit grant flow exposes tokens directly to your users.
#   # Select "client_credentials" to pass access tokens to your app based on its knowledge not of user credentials, but of the client secret. The client credentials grant flow is mututally exclusive with authorization code and implicit grant flows.
#   allowed_oauth_flows = ["implicit"]
#   # The phone scope grants access to the phone_number and phone_number_verified claims. This scope can only be requested with the openid scope.
#   # The email scope grants access to the email and email_verified claims. This scope can only be requested with the openid scope.
#   # The openid scope declares that you want to retrieve scopes that align with the OpenID Connect specification. Amazon Cognito doesn't return an ID token unless you request the openid scope.
#   # The aws.cognito.signin.user.admin scope grants access to Amazon Cognito user pool API operations that require access tokens, such as UpdateUserAttributes and VerifyUserAttribute.
#   # The profile scope grants access to all user attributes that are readable by the client. This scope can only be requested with the openid scope.
#   allowed_oauth_scopes         = ["email", "openid"]
#   supported_identity_providers = ["COGNITO"]
# }


# # app integration


# resource "aws_cognito_user_pool_domain" "user-pool-domain" {
#   domain       = "jwt-pool"
#   user_pool_id = aws_cognito_user_pool.jwt-user-pool.id
# }


# resource "aws_cognito_user" "pmbibe" {
#   user_pool_id       = aws_cognito_user_pool.jwt-user-pool.id
#   username           = "pmbibe"
#   temporary_password = "123456A@a"
# }