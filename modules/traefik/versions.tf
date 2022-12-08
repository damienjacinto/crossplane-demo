terraform {
  required_providers {
    kubectl = {
      source = "gavinbunney/kubectl"
      version = "1.14.0"
    }
    aws = {
      source = "hashicorp/aws"
      version = "4.45.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.16.1"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.7.1"
    }
  }
  required_version = "~> 1.0"
}