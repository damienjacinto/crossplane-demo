provider "kubectl" {
  host = var.reflector_cluster_host
  cluster_ca_certificate = base64decode(var.reflector_cluster_ca_certificate)
  token = data.aws_eks_cluster_auth.eks_cluster_auth.token
}

provider "kubernetes" {
  host = var.reflector_cluster_host
  cluster_ca_certificate = base64decode(var.reflector_cluster_ca_certificate)
  token = data.aws_eks_cluster_auth.eks_cluster_auth.token
}

provider "helm" {
  kubernetes {
    host = var.reflector_cluster_host
    cluster_ca_certificate = base64decode(var.reflector_cluster_ca_certificate)
    token = data.aws_eks_cluster_auth.eks_cluster_auth.token
  }
}