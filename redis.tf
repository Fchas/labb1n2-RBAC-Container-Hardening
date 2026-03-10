# redis.tf — instantiate module for Redis

module "redis" {
  source    = "./modules/k8s-app"
  name      = "redis"
  namespace = var.namespace
  image     = var.redis_image
  port      = 6379

  # override defaults if needed
  cpu_request    = "100m"
  memory_request = "128Mi"
  cpu_limit      = "200m"
  memory_limit   = "256Mi"
}

