resource "helm_release" "monitor" {
  name = "prometheus"

  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"

  depends_on = [module.eks]
}

