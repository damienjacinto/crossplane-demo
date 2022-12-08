module "eks" {
  source = "terraform-aws-modules/eks/aws"

  cluster_name                     = local.name
  cluster_version                  = local.cluster_version
  cluster_endpoint_public_access   = true
  cluster_encryption_config        = {}

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.intra_subnets

  cluster_enabled_log_types = []

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  manage_aws_auth_configmap = false
  tags = local.tags
}