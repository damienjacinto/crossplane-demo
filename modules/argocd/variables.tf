variable "argocd_chart_version" {
  type        = string
  description = "Argocd chart helm version"
}

variable "argocd_certificate_secret_name" {
  type        = string
  description = "Secret name for tls certificate"
}

variable "argocd_domain" {
  type    = string
  default = ""
}

variable "argocd_github_token" {
  type    = string
  default = ""
}

variable "argocd_github_repo" {
  type    = string
  default = "https://github.com/damienjacinto"
}

variable "argocd_github_oauth_client_id" {
  type    = string
  default = ""
}

variable "argocd_github_oauth_client_secret" {
  type    = string
  default = ""
}

variable "argocd_cluster_name" {
  type    = string
  default = ""
}

variable "argocd_cluster_host" {
  type    = string
  default = ""
}

variable "argocd_cluster_ca_certificate" {
  type    = string
  default = ""
}

variable "argocd_issuer_name" {
  type    = string
  default = ""
}