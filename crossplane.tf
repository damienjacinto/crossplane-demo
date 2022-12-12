module "crossplane" {
  source                            = "./modules/crossplane"
  crossplane_cluster_name           = module.eks.cluster_name
  crossplane_cluster_host           = module.eks.cluster_endpoint
  crossplane_cluster_ca_certificate = module.eks.cluster_certificate_authority_data
  crossplane_chart_version          = local.crossplane_chart_version
  crossplane_role                   = var.crossplane_role
}
