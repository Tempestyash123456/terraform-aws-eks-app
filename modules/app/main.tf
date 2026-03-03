resource "time_sleep" "wait_for_cluster" {
  create_duration = "240s"
}

resource "null_resource" "verify_k8s_connection" {
  depends_on = [time_sleep.wait_for_cluster]

  provisioner "local-exec" {
    command = <<-EOT
      echo "Setting up kubeconfig..."

      aws eks update-kubeconfig --region ${var.aws_region} --name ${var.cluster_name} --kubeconfig kubeconfig_temp

      if [ $? -ne 0 ]; then
        echo "Failed to update kubeconfig"
        exit 1
      fi

      echo "Waiting for Kubernetes API to be available..."
      maxRetries=30
      retryCount=0

      while [ $retryCount -lt $maxRetries ]; do
        if kubectl get nodes --kubeconfig kubeconfig_temp --request-timeout=5s >/dev/null 2>&1; then
          echo "Kubernetes API is available"
          mkdir -p ~/.kube
          cp kubeconfig_temp ~/.kube/config
          echo "Kubeconfig installed to ~/.kube/config"
          exit 0
        fi

        retryCount=$((retryCount + 1))
        echo "Waiting for API... ($retryCount/$maxRetries)"
        sleep 10
      done

      echo "Kubernetes API not available after $maxRetries attempts"
      exit 1
    EOT
  }
}

resource "kubernetes_namespace_v1" "app" {
  count = var.app_namespace != "default" ? 1 : 0

  metadata {
    name = var.app_namespace
  }

  depends_on = [null_resource.verify_k8s_connection]
}

locals {
  app_namespace    = var.app_namespace != "default" ? kubernetes_namespace_v1.app[0].metadata[0].name : "default"
  safe_deploy_name = "app-${replace(var.app_image, "/[^a-z0-9-]/", "-")}"
}

data "kubernetes_nodes" "existing" {
  depends_on = [null_resource.verify_k8s_connection]
}

resource "kubernetes_deployment_v1" "app" {
  metadata {
    name      = local.safe_deploy_name
    namespace = local.app_namespace
  }

  spec {
    replicas = var.app_replicas

    strategy {
      type = "RollingUpdate"
      rolling_update {
        max_surge       = "25%"
        max_unavailable = "25%"
      }
    }

    selector {
      match_labels = {
        app = "myapp"
      }
    }

    template {
      metadata {
        labels = {
          app = "myapp"
        }
      }

      spec {
        container {
          image = var.app_image
          name  = "myapp"

          port {
            container_port = var.app_container_port
          }

          resources {
            requests = {
              cpu    = "256m"
              memory = "512Mi"
            }
          }

          liveness_probe {
            http_get {
              path = "/"
              port = var.app_container_port
            }
            initial_delay_seconds = 30
            period_seconds        = 10
          }

          readiness_probe {
            http_get {
              path = "/"
              port = var.app_container_port
            }
            initial_delay_seconds = 5
            period_seconds        = 5
          }
        }
      }
    }
  }

  timeouts {
    create = "15m"
    update = "10m"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "kubernetes_service_v1" "app" {
  metadata {
    name      = "app-service"
    namespace = local.app_namespace
    annotations = {
      "service.beta.kubernetes.io/aws-load-balancer-type"   = "nlb"
      "service.beta.kubernetes.io/aws-load-balancer-scheme" = "internet-facing"
    }
  }

  spec {
    selector = {
      app = "myapp"
    }

    port {
      port        = 80
      target_port = var.app_container_port
    }

    type = var.app_service_type
  }

  depends_on = [kubernetes_deployment_v1.app]
}
