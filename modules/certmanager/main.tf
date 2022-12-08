locals {
    certmanager = "certmanager"
}

data "aws_eks_cluster" "eks_cluster" {
  name = var.certmanager_cluster_name
}

data "aws_eks_cluster_auth" "eks_cluster_auth" {
  name = var.certmanager_cluster_name
}

resource "helm_release" "certmanager" {
  name             = local.certmanager
  chart            = "cert-manager"
  repository       = "https://charts.jetstack.io"
  version          = var.certmanager_chart_version
  namespace        = local.certmanager
  create_namespace = true
  force_update     = false
  recreate_pods    = true
  wait             = true
  values = [<<EOF
    installCRDs: true
EOF
]
}

# Wait for helm operator to install certmanager crd (no data for crd at this moment in the kubernetes provider)
resource "time_sleep" "wait_60_seconds" {
  depends_on      = [helm_release.certmanager]
  create_duration = "60s"
}

resource "kubectl_manifest" "certmanager_issuer" {
  depends_on = [time_sleep.wait_60_seconds]
  yaml_body  = templatefile("${path.module}/templates/clusterissuer.yml", {
    namespace        = helm_release.certmanager.namespace
    name             = var.certmanager_clusterissuer_name
    email            = var.certmanager_email
    issuerAccountKey = var.certmanager_issuer_account_key
    domain           = var.certmanager_domain
    ingressClass     = var.certmanager_ingress_class
  })
}
