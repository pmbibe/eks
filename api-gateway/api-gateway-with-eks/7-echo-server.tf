resource "kubernetes_deployment_v1" "echoserver" {
  metadata {
    name = "echo-server-deployment"
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "echo-server"
      }
    }
    template {
      metadata {
        labels = {
          app = "echo-server"
        }
      }
      spec {
        container {
          image = "ealen/echo-server"
          name  = "echo-server"
          port {
            container_port = "80"
          }
        }
      }
    }
  }

  depends_on = [helm_release.helm-alb-controller]
}

resource "kubernetes_service_v1" "echo-service" {
  wait_for_load_balancer = true
  metadata {
    name = "echo-server-service"
    annotations = {
      "alb.ingress.kubernetes.io/load-balancer-name" : "echo-server"
      "kubernetes.io/ingress.class" : "alb"
      "alb.ingress.kubernetes.io/target-type" : "ip"
      "alb.ingress.kubernetes.io/scheme" : "internal"
      "alb.ingress.kubernetes.io/tags" : "Name = echo-server, Env = Dev"
    }
  }
  spec {
    selector = {
      app = "echo-server"
    }
    type = "LoadBalancer"
    port {
      port        = 80
      protocol    = "TCP"
    }
  }
  depends_on = [kubernetes_deployment_v1.echoserver]
}