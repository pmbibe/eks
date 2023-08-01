locals {
  annotations = {
    "eks.amazonaws.com/role-arn" : aws_iam_role.alb_role.arn
  }
}
resource "kubernetes_service_account" "alb-controller" {
  metadata {
    name        = "aws-load-balancer-controller"
    namespace   = "kube-system"
    annotations = local.annotations
    labels = {
      "app.kubernetes.io/component" : "controller"
      "app.kubernetes.io/name" : local.serviceaccount
    }
  }

  depends_on = [module.eks]

}
resource "helm_release" "helm-alb-controller" {
  name       = "alb-controller"
  namespace  = "kube-system"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"

  set {
    name  = "clusterName"
    value = module.eks.cluster_name
  }
  set {
    name  = "serviceAccount.create"
    value = "false"
  }
  set {
    name  = "serviceAccount.name"
    value = local.serviceaccount
  }
  set {
    name  = "region"
    value = "us-east-1"
  }
  set {
    name  = "vpcId"
    value = module.vpc.vpc_id
  }
  depends_on = [kubernetes_service_account.alb-controller]
}

