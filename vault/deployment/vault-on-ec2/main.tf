terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-central-1"
}


module "vault" {
  source  = "hashicorp/vault/aws"
  version = "0.17.0"
  # insert the 4 required variables here
}