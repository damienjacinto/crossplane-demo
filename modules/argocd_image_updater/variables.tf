variable "argocd_image_updater_chart_version" {
  type        = string
  description = "Argocd image updater chart helm version"
}

variable "argocd_image_updater_cluster_name" {
  type    = string
  default = ""
}

variable "argocd_image_updater_cluster_host" {
  type    = string
  default = ""
}

variable "argocd_image_updater_cluster_ca_certificate" {
  type    = string
  default = ""
}

variable "argocd_image_updater_awsregion" {
  type    = string
  default = "eu-central-1"
}

variable "argocd_image_updater_registry" {
  type    = string
  default = ""
}

variable "argocd_image_updater_role" {
  type    = string
  default = ""
}

variable "argocd_token" {
  type    = string
  default = ""
}
