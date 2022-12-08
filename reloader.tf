module "reflector" {
  source                         = "./modules/reflector"
  reflector_cluster_name           = module.eks.cluster_name
  reflector_cluster_host           = module.eks.cluster_endpoint
  reflector_cluster_ca_certificate = module.eks.cluster_certificate_authority_data
  reflector_chart_version          = local.reflector_chart_version
}