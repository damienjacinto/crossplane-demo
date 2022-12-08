variable "reflector_cluster_host" {
  type        = string
  description = "Cluster host"
}

variable "reflector_cluster_ca_certificate" {
  type        = string
  description = "Cluster ca certificate"
  sensitive   = true
}

variable "reflector_cluster_name" {
  type        = string
  description = "Cluster name"
  default     = ""
}

variable "reflector_chart_version" {
  type        = string
  description = "Reflector chart version"
}
