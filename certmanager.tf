module "certmanager" {
  source                             = "./modules/certmanager"
  certmanager_cluster_host           = module.eks.cluster_endpoint
  certmanager_cluster_ca_certificate = module.eks.cluster_certificate_authority_data
  certmanager_cluster_name           = module.eks.cluster_name
  certmanager_chart_version          = local.certmanager_chart_version
  certmanager_email                  = local.email
  certmanager_domain                 = local.domain
}