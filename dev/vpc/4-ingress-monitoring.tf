resource "kubernetes_ingress_v1" "prometheus-grafana" {
  wait_for_load_balancer = true
  metadata {
    name = "prometheus-grafana"
    annotations = {
      "kubernetes.io/ingress.class" : "alb"
      "alb.ingress.kubernetes.io/target-type" : "ip"
      "alb.ingress.kubernetes.io/scheme" : "internet-facing"
    }
  }

  spec {
    ingress_class_name = "alb"
    rule {
      host = "*.amazonaws.com"
      http {
        path {
          path = "/*"
          backend {
            service {
              name = "prometheus-grafana"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
  depends_on = [helm_release.monitor, helm_release.helm-alb-controller]
}
