terraform {
  required_providers {
    kubernetes = { source = "hashicorp/kubernetes", version = "~> 2.30" }
    helm       = { source = "hashicorp/helm", version = "~> 2.13" }
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "minikube"
}
provider "helm" {
  kubernetes {
    config_path    = "~/.kube/config"
    config_context = "minikube"
  }
}

resource "kubernetes_namespace" "app" {
  metadata { name = "githook-shield" }
}

resource "kubernetes_namespace" "monitoring" {
  metadata { name = "monitoring" }
}

resource "helm_release" "monitoring" {
  name       = "kps"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  timeout    = 900
  values     = [file("${path.module}/monitoring-values.yaml")]
}

resource "kubernetes_deployment" "app" {
  metadata {
    name      = "githook-shield"
    namespace = kubernetes_namespace.app.metadata[0].name
    labels    = { app = "githook-shield" }
  }
  spec {
    replicas = 2
    selector { match_labels = { app = "githook-shield" } }
    template {
      metadata { labels = { app = "githook-shield" } }
      spec {
        container {
          name              = "app"
          image             = var.app_image
          image_pull_policy = "Never"
          port { container_port = 5000 }
          readiness_probe {
            http_get {
              path = "/health"
              port = 5000
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "app" {
  metadata {
    name      = "githook-shield"
    namespace = kubernetes_namespace.app.metadata[0].name
    labels    = { app = "githook-shield" }
  }
  spec {
    selector = { app = "githook-shield" }
    type     = "NodePort"
    port {
      name        = "http"
      port        = 80
      target_port = 5000
    }
  }
}