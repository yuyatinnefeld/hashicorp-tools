module "cloud_storage" {
  source           = "./modules/storage"
  region           = var.region
  env              = var.env
}

module "bigquery_datasets" {
  source           = "./modules/bigquery"
  region           = var.region
}

module "network" {
  source           = "./modules/network"
  region           = var.region
  vpc_network_name = var.vpc_network_name
}