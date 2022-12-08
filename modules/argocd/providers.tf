provider "kubectl" {
  host = var.argocd_cluster_host
  cluster_ca_certificate = base64decode(var.argocd_cluster_ca_certificate)
  token = data.aws_eks_cluster_auth.eks_cluster_auth.token
}

provider "kubernetes" {
  host = var.argocd_cluster_host
  cluster_ca_certificate = base64decode(var.argocd_cluster_ca_certificate)
  token = data.aws_eks_cluster_auth.eks_cluster_auth.token
}

provider "helm" {
  kubernetes {
    host = var.argocd_cluster_host
    cluster_ca_certificate = base64decode(var.argocd_cluster_ca_certificate)
    token = data.aws_eks_cluster_auth.eks_cluster_auth.token
  }
}