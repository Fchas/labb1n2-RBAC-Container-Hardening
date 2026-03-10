# api.tf — API deployment, service, and configmap

resource "kubernetes_config_map" "api_config" {
  metadata {
    name      = "api-config"
    namespace = var.namespace
    labels = {
      app = "api"
    }
  }
  data = {
    TEAM_NAME   = var.team_name
    NAMESPACE   = var.namespace
    REDIS_HOST  = "redis-service"
    REDIS_PORT  = "6379"
    PORT        = "3000"
  }
}

module "api" {
  source    = "./modules/k8s-app"
  name      = "api"
  namespace = var.namespace
  image     = var.api_image
  port      = 3000
  replicas  = var.api_replicas

  labels = {
    tier = "backend"
  }

  env_vars = {
    REDIS_HOST = "redis-service"
    REDIS_PORT = "6379"
    NODE_ENV   = var.environment
  }

  cpu_request    = "100m"
  memory_request = "128Mi"
  cpu_limit      = "200m"
  memory_limit   = "256Mi"
}
