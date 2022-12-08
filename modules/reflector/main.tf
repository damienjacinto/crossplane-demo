locals {
  reflector = "reflector"
}

data "aws_eks_cluster" "eks_cluster" {
  name = var.reflector_cluster_name
}

data "aws_eks_cluster_auth" "eks_cluster_auth" {
  name = var.reflector_cluster_name
}

resource "helm_release" "reflector" {
  name             = local.reflector
  repository       = "https://emberstack.github.io/helm-charts"
  chart            = local.reflector
  namespace        = local.reflector
  version          = var.reflector_chart_version
  create_namespace = true
  force_update     = false
  recreate_pods    = true
  wait             = true
}