module "argocd_image_updater" {
  source                                      = "./modules/argocd_image_updater"
  argocd_image_updater_cluster_name           = module.eks.cluster_name
  argocd_image_updater_cluster_host           = module.eks.cluster_endpoint
  argocd_image_updater_cluster_ca_certificate = module.eks.cluster_certificate_authority_data
  argocd_image_updater_chart_version          = local.argocd_image_updater_chart_version
  argocd_image_updater_registry               = var.argocd_image_updater_registry
  argocd_image_updater_role                   = var.argocd_image_updater_role
  argocd_token                                = var.argocd_token
}
