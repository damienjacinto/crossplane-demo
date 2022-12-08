module "argocd" {
  source                            = "./modules/argocd"
  argocd_cluster_name               = module.eks.cluster_name
  argocd_cluster_host               = module.eks.cluster_endpoint
  argocd_cluster_ca_certificate     = module.eks.cluster_certificate_authority_data
  argocd_chart_version              = local.argocd_chart_version
  argocd_certificate_secret_name    = "argocd-certificate"
  argocd_github_token               = var.argocd_github_token
  argocd_domain                     = local.argocd_domain
  argocd_github_oauth_client_id     = var.argocd_github_oauth_client_id
  argocd_github_oauth_client_secret = var.argocd_github_oauth_client_secret
  argocd_issuer_name                = module.certmanager.clusterissuer_name
}