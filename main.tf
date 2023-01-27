provider "aws" {
<<<<<<< HEAD
  region   = "ap-south-1"
=======
  region = "ap-south-1"
>>>>>>> af0a024942ae1cdf10f7e4c272f7f77c01b37f71
}

terraform {
  required_version = "~> 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.63"
    }
  }

  backend "s3" {
    bucket               = "ocpame2-sb-tfs-115901469345-001"
    key                  = "workloads-devops-test-vpc-1.tfstate"
    workspace_key_prefix = "workspaces"
    region               = "eu-west-1"
  }
}