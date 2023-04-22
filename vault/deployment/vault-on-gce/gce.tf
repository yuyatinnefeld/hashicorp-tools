terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
    }
  }
}

provider "google" {
  project = var.project
  zone  = var.zone
}


module "vault_example_vault-on-gce" {
  source  = "terraform-google-modules/vault/google//examples/vault-on-gce"
  version = "7.0.0"
  project_id = var.project
}
