# variables.tf — All configurable values in one place

# Kubernetes connection (optional - can rely on env vars)
variable "kubeconfig_path" {
  description = "Path to the Kubernetes kubeconfig file"
  type        = string
  default     = "~/.kube/config"
}

variable "kube_context" {
  description = "Kubernetes context to use"
  type        = string
  default     = ""
}

# Team-specific values
variable "namespace" {
  description = "Kubernetes namespace for your team"
  type        = string
  default     = "fchas-lab1n2-lillteamet"
}

variable "team_name" {
  description = "Human-readable team name"
  type        = string
  default     = "Fchas-lab1n2-lillteamet"
}

# Deployment settings
variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "production"
  validation {
    condition     = contains(["development","staging","production"], var.environment)
    error_message = "Environment must be development, staging, or production."
  }
}

# Container images
variable "redis_image" {
  description = "Redis container image"
  type        = string
  default     = "redis:7-alpine"
}

variable "api_image" {
  description = "API backend container image"
  type        = string
  default     = "gcr.io/chas-devsecops-2026/team-dashboard-api:v2-hardened"
}

variable "frontend_image" {
  description = "Frontend container image"
  type        = string
  default     = "gcr.io/chas-devsecops-2026/team-dashboard-frontend:v1"
}

variable "api_replicas" {
  description = "Number of API replicas"
  type        = number
  default     = 2
  validation {
    condition     = var.api_replicas >= 1 && var.api_replicas <= 3
    error_message = "Replicas must be between 1 and 3 (namespace quota limit)."
  }
}

