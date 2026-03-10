# example.tfvars — template values (commit this one to Git)

namespace    = "your-namespace"
team_name    = "Your Team Name"
environment  = "development"
api_replicas = 1

# optionally override kubeconfig_path or context
# kubeconfig_path = "~/.kube/config"
# kube_context    = "gke_project_zone_cluster"
