locals {
  crossplane = "crossplane"
}
data "aws_eks_cluster" "eks_cluster" {
  name = var.crossplane_cluster_name
}

data "aws_eks_cluster_auth" "eks_cluster_auth" {
  name = var.crossplane_cluster_name
}

resource "helm_release" "crossplane" {
  name             = local.crossplane
  namespace        = "crossplane-system"
  repository       = "https://charts.crossplane.io/stable"
  chart            = local.crossplane
  version          = var.crossplane_chart_version
  create_namespace = true
  force_update     = false
  recreate_pods    = true
  wait             = true
}

resource "kubectl_manifest" "crossplane_provider_aws" {
  wait      = true
  yaml_body = templatefile("${path.module}/templates/provider-aws.yml", {
    namespace            = helm_release.crossplane.namespace
    version_provider_aws = var.crossplane_version_provider_aws
  })
}

resource "kubectl_manifest" "crossplane_controller_config" {
  yaml_body = templatefile("${path.module}/templates/controller-config.yml", {
    namespace = kubectl_manifest.crossplane_provider_aws.namespace
    role      = var.crossplane_role
  })
}

resource "kubectl_manifest" "crossplane_provider_config" {
  yaml_body = templatefile("${path.module}/templates/provider-config.yml", {
    namespace = kubectl_manifest.crossplane_provider_aws.namespace
    role      = var.crossplane_role
  })
}
