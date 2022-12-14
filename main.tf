locals {
  name             = "meetup"
  cluster_version  = "1.24"
  region           = "eu-central-1"
  email            = "djacinto@peaks.fr"
  repo_bootstrap   = "https://github.com/damienjacinto/app-meetup-argocd.git"
  admin_user_email = "damien.jacinto@gmail.com"

  domain          = "meetup-peaks.ddns.net"
  traefik_domain  = "traefik.${local.domain}"
  argocd_domain   = "argocd.${local.domain}"

  certmanager_chart_version          = "v1.10.1"
  traefik_chart_version              = "20.6.0"
  reflector_chart_version            = "6.1.47"
  argocd_chart_version               = "5.16.0"
  argocd_image_updater_chart_version = "0.8.1"
  crossplane_chart_version           = "1.10.1"

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  tags = {
    Example = local.name
  }
}

