module "traefik" {
  source                          = "./modules/traefik"
  traefik_cluster_name            = module.eks.cluster_name
  traefik_cluster_host            = module.eks.cluster_endpoint
  traefik_cluster_ca_certificate  = module.eks.cluster_certificate_authority_data
  traefik_chart_version           = local.traefik_chart_version
  traefik_issuer_name             = module.certmanager.clusterissuer_name
  traefik_domain                  = local.traefik_domain
  traefik_certificate_secret_name = "traefik-certificate"
}