locals {
  odic_url       = split("https://", module.eks.cluster_oidc_issuer_url)[1]
  namespace      = "kube-system"
  serviceaccount = "aws-load-balancer-controller"
  version        = "2012-10-17"
  statement = [
    {
      Effect = "Allow"
      Principal = {
        Federated = module.eks.oidc_provider_arn
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          format("%s:aud", local.odic_url) = "sts.amazonaws.com"
          format("%s:sub", local.odic_url) = format("system:serviceaccount:%s:%s", local.namespace, local.serviceaccount)
        }
      }
    }
  ]
}

# data "aws_iam_openid_connect_provider" "oidc_eks" {
#   url = module.eks.cluster_oidc_issuer_url
# }

resource "aws_iam_role" "alb_role" {
  name = "AmazonEKSLoadBalancerControllerRole"

  assume_role_policy = jsonencode({
    Version   = local.version
    Statement = local.statement
  })
  depends_on = [module.eks]
}

resource "aws_iam_policy_attachment" "alb_policy_attachment" {
  name       = "Policy Attachement"
  policy_arn = aws_iam_policy.alb_policy.arn
  roles      = [aws_iam_role.alb_role.name]
  depends_on = [aws_iam_policy.alb_policy, aws_iam_role.alb_role]
}