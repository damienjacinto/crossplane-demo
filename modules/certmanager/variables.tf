variable "certmanager_cluster_host" {
  type        = string
  description = "Cluster host"
}

variable "certmanager_cluster_ca_certificate" {
  type        = string
  description = "Cluster ca certificate"
  sensitive   = true
}

variable "certmanager_cluster_name" {
  type        = string
  description = "Cluster name"
  default     = ""
}

variable "certmanager_chart_version" {
  type        = string
  description = "Certmanager chart version"
}

variable "certmanager_clusterissuer_name" {
  type        = string
  description = "Clusterissuer name"
  default     = "letsencrypt"
}

variable "certmanager_ingress_class" {
  type        = string
  description = "Ingress class with ssl"
  default     = "traefik"
}

variable "certmanager_email" {
  type        = string
  description = "Email for certmanager"
  default     = ""
}

variable "certmanager_issuer_account_key" {
  type        = string
  description = "Secret key for issuer"
  default     = "issuer-account-key"
}

variable "certmanager_domain" {
  type        = string
  description = "Domain for wildcard"
  default     = ""
}