variable "crossplane_cluster_host" {
  type        = string
  description = "Cluster host"
}

variable "crossplane_cluster_ca_certificate" {
  type        = string
  description = "Cluster ca certificate"
  sensitive   = true
}

variable "crossplane_cluster_name" {
  type        = string
  description = "Cluster name"
  default     = ""
}

variable "crossplane_chart_version" {
  type        = string
  description = "Crossplane chart version"
}

variable "crossplane_role" {
  type        = string
  description = "Crossplane role arn for aws provider"
}

variable "crossplane_version_provider_aws" {
  type        = string
  description = "Crossplane provider aws version"
  default     = "v0.24.1"
  #"v0.34.0"
}
