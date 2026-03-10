# frontend.tf — instantiate module for frontend

module "frontend" {
  source    = "./modules/k8s-app"
  name      = "frontend"
  namespace = var.namespace
  image     = var.frontend_image
  port      = 80
  replicas  = 2

  cpu_request    = "100m"
  memory_request = "128Mi"
  cpu_limit      = "200m"
  memory_limit   = "256Mi"
}

