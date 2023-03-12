terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.0.0"
    }
  }
}

provider "google" {
  project = var.project
  region  = var.region   
  zone    = var.zone
}

module "cloud_storage" {
  source           = "./module/storage"
  region           = var.region
  env              = var.env
}

module "network" {
  source           = "./module/network"
  region           = var.region
  vpc_network_name = var.vpc_network_name
}
