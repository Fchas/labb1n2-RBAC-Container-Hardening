# ingress.tf — HTTP/HTTPS ingress and certificate

resource "kubernetes_ingress_v1" "team_dashboard" {
  metadata {
    name      = "team-dashboard"
    namespace = var.namespace
    labels = {
      app = "team-dashboard"
    }
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
    }
  }
  spec {
    rule {
      host = "${var.namespace}.chas.retro87.se"
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = module.frontend.service_name
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}

# Certificate CRD via manifest (requires cert-manager to be installed)
# Uncomment this block when deploying to GKE with cert-manager installed
# resource "kubernetes_manifest" "certificate" {
#   manifest = {
#     apiVersion = "cert-manager.io/v1"
#     kind       = "Certificate"
#     metadata = {
#       name      = "team-dashboard-tls"
#       namespace = var.namespace
#       labels = {
#         app = "team-dashboard"
#       }
#     }
#     spec = {
#       secretName = "team-dashboard-tls"
#       issuerRef = {
#         name = "letsencrypt-prod"
#         kind = "ClusterIssuer"
#       }
#       dnsNames = ["${var.namespace}.chas.retro87.se"]
#       usages    = ["digital signature","key encipherment"]
#     }
#   }
# }


# TLS-enabled ingress (requires cert-manager)
# For GKE production: uncomment this and comment out the HTTP ingress above
# resource "kubernetes_ingress_v1" "team_dashboard_tls" {
#   metadata {
#     name      = "team-dashboard-tls"
#     namespace = var.namespace
#     labels = {
#       app = "team-dashboard"
#     }
#     annotations = {
#       "kubernetes.io/ingress.class"                        = "nginx"
#       "cert-manager.io/cluster-issuer"                     = "letsencrypt-prod"
#       "nginx.ingress.kubernetes.io/force-ssl-redirect"     = "true"
#       "nginx.ingress.kubernetes.io/ssl-protocols"         = "TLSv1.2 TLSv1.3"
#     }
#   }
#   spec {
#     tls {
#       hosts       = ["${var.namespace}.chas.retro87.se"]
#       secret_name = "team-dashboard-tls"
#     }
#     rule {
#       host = "${var.namespace}.chas.retro87.se"
#       http {
#         path {
#           path      = "/"
#           path_type = "Prefix"
#           backend {
#             service {
#               name = module.frontend.service_name
#               port {
#                 number = 80
#               }
#             }
#           }
#         }
#       }
#     }
#   }
# }
