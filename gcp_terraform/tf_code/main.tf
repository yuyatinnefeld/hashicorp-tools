terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "google" {
  credentials = file("conf/service_account.json")

  project = "gcp-terraform-320011"
  region  = "europe-west3"
  zone    = "europe-west3-b"
}

resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}

