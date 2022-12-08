locals {
  argocd = "argocd"
  rbac = <<RBAC
        p, role:app, applications, get, default/*, allow
        p, role:app, applications, sync, default/*, allow
        p, role:app, applications, update, default/*, allow
        p, role:app, applications, action, default/*, allow
        p, role:app, applications, override, default/*, allow
        p, role:app, applications, delete, default/*, allow
        p, role:app, applications, action/apps/Deployment/restart, default/*, allow
        p, role:app, clusters, get, *, allow
        p, role:app, repositories, get, *, allow
        p, role:app, projects, get, *, allow
        p, role:app, exec, create, */*, allow
RBAC
}

data "aws_eks_cluster" "eks_cluster" {
  name = var.argocd_cluster_name
}

data "aws_eks_cluster_auth" "eks_cluster_auth" {
  name = var.argocd_cluster_name
}

resource "helm_release" "argocd" {
  name             = local.argocd
  namespace        = local.argocd
  repository       = "https://argoproj.github.io/argo-helm/"
  chart            = "argo-cd"
  version          = var.argocd_chart_version
  create_namespace = true
  force_update     = false
  recreate_pods    = true
  wait             = true
  values = [templatefile("${path.module}/templates/values.yml", {
    url                        = "https://${var.argocd_domain}"
    github_oauth_client_id     = var.argocd_github_oauth_client_id
    github_oauth_client_secret = var.argocd_github_oauth_client_secret
    policies                   = local.rbac
  })]
}

resource "kubectl_manifest" "argocd_ingress" {
  yaml_body = templatefile("${path.module}/templates/ingressroute-dashboard.yml", {
    namespace               = helm_release.argocd.namespace
    domain                  = var.argocd_domain
    certificate_secret_name = var.argocd_certificate_secret_name
  })
  depends_on = [helm_release.argocd]
}

resource "kubernetes_secret" "argo_github_credential" {
  metadata {
    name      = "argo-github-credential"
    namespace = helm_release.argocd.namespace
    labels = {
      "argocd.argoproj.io/secret-type" = "repo-creds"
    }
  }
  data = {
    password = var.argocd_github_token
    url      = var.argocd_github_repo
    username = "github"
  }
  type = "Opaque"
}

resource "kubectl_manifest" "certificate" {
  yaml_body = templatefile("${path.module}/templates/certificate.yml", {
    namespace   = helm_release.argocd.namespace
    domain      = var.argocd_domain
    issuer_name = var.argocd_issuer_name
    secret_name = var.argocd_certificate_secret_name
  })
}