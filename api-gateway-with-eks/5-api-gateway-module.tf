
locals {
  echo_svc_name_list = split("-", split(".", kubernetes_service_v1.echo-service.status.0.load_balancer.0.ingress.0.hostname)[0])
  echo_svc_name      = join("-", slice(local.echo_svc_name_list, 0, 4))
}
data "aws_lb" "echo_svc_lb" {
  name = local.echo_svc_name
}
data "aws_lb_listener" "echo_svc_lb" {
  load_balancer_arn = data.aws_lb.echo_svc_lb.arn
  port              = 80
}


module "apigateway-v2" {

  source  = "terraform-aws-modules/apigateway-v2/aws"
  version = "2.2.2"
  name    = "dev-api-gateway"
  #   The API protocol. Valid values: HTTP, WEBSOCKET
  protocol_type          = "HTTP"
  create_default_stage   = true
  create_api_domain_name = false
  vpc_links = {
    my-vpc = {
      name               = "vpc-link"
      security_group_ids = [module.vpc_link_service_sg.security_group_id]
      subnet_ids         = module.vpc.private_subnets
    }


  }
  integrations = {
    "GET /" = {
      description     = "integration with eks"
      vpc_link        = "my-vpc"
      integration_uri = data.aws_lb_listener.echo_svc_lb.arn
      integration_method = "ANY"
      integration_type   = "HTTP_PROXY"
      connection_type    = "VPC_LINK"

    }
  }
  depends_on = [module.vpc, module.eks, kubernetes_service_v1.echo-service]

}