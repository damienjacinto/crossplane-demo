locals {
  argocd = "argocd"
  rbac = <<RBAC
        p, role:org-admin, applications, *, */*, allow
        p, role:org-admin, clusters, get, *, allow
        p, role:org-admin, repositories, get, *, allow
        p, role:org-admin, repositories, create, *, allow
        p, role:org-admin, repositories, update, *, allow
        p, role:org-admin, repositories, delete, *, allow
        p, role:image-updater, applications, get, *, allow
        p, role:image-updater, applications, upadte, *, allow
        g, image-updater, role:image-updater
        g, ${var.argocd_github_admin_user_email}, role:org-admin
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

resource "kubectl_manifest" "argocd_bootstrap_app" {
  yaml_body = templatefile("${path.module}/templates/bootstrap-app.yml", {
    namespace      = helm_release.argocd.namespace
    repo_bootstrap = var.argocd_repo_bootstrap
  })
}
