terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.35"
    }
  }

  # GCS backend for production/GKE deployment
  # Uncomment and run 'terraform init -migrate-state' when deploying to GKE
  # For local Minikube development, comment this out
  # backend "gcs" {
  #   bucket = "chas-tf-state-fchas-lab1n2-lillteamet"  # your team's bucket
  #   prefix = "terraform/state"
  # }
}

# Kubernetes provider configuration – uses kubeconfig path/context if provided,
# otherwise Terraform will default to $KUBECONFIG or ~/.kube/config.
provider "kubernetes" {
  config_path    = var.kubeconfig_path
  config_context = var.kube_context
}

# Ensure namespace exists
# Note: In school/shared environments, the namespace is usually pre-created by admin
# Uncomment this block if you need Terraform to create the namespace
# resource "kubernetes_namespace" "team" {
#   metadata {
#     name = var.namespace
#     labels = {
#       team        = var.namespace
#       managed-by  = "terraform"
#     }
#   }
# }

