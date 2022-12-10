locals {
  argocd_image_updater = "argocd-image-updater"
}

data "aws_eks_cluster" "eks_cluster" {
  name = var.argocd_image_updater_cluster_name
}

data "aws_eks_cluster_auth" "eks_cluster_auth" {
  name = var.argocd_image_updater_cluster_name
}

resource "helm_release" "argocd_image_updater" {
  name             = local.argocd_image_updater
  namespace        = "argocd"
  repository       = "https://argoproj.github.io/argo-helm/"
  chart            = "argocd-image-updater"
  version          = var.argocd_image_updater_chart_version
  create_namespace = true
  force_update     = false
  recreate_pods    = true
  wait             = true
  values = [templatefile("${path.module}/templates/values.yml", {
    awsregion   = var.argocd_image_updater_awsregion
    registry    = var.argocd_image_updater_registry
    role        = var.argocd_image_updater_role
    argocdtoken = var.argocd_token
  })]
}
