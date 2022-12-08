locals {
    traefik = "traefik"
}

data "aws_eks_cluster" "eks_cluster" {
  name = var.traefik_cluster_name
}

data "aws_eks_cluster_auth" "eks_cluster_auth" {
  name = var.traefik_cluster_name
}

resource "helm_release" "traefik" {
  name             = local.traefik
  chart            = local.traefik
  namespace        = local.traefik
  repository       = "https://helm.traefik.io/traefik"
  version          = var.traefik_chart_version
  create_namespace = true
  force_update     = false
  recreate_pods    = true
  wait             = true
  values = [<<EOF
    deployment:
      kind: DaemonSet
    service:
      type: LoadBalancer
    globalArguments: []
    additionalArguments:
    - "--api.insecure=true"
EOF
]
}

resource "kubectl_manifest" "ingressroute_dashboard" {
  yaml_body = templatefile("${path.module}/templates/ingressroute-dashboard.yml", {
    namespace               = helm_release.traefik.namespace
    dns                     = var.traefik_domain
    certificate_secret_name = var.traefik_certificate_secret_name
  })
}

resource "kubectl_manifest" "certificate" {
  yaml_body = templatefile("${path.module}/templates/certificate.yml", {
    namespace   = helm_release.traefik.namespace
    domain      = var.traefik_domain
    issuer_name = var.traefik_issuer_name
    secret_name = var.traefik_certificate_secret_name
  })
}