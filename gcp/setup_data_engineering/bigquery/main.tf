terraform {

  backend "remote" {
    organization = "yuyatinnefeld"

    workspaces {
      name = "GCP-terraform-yuya"
    }
  }
  
  
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "google" {
  credentials = file(var.cred)

  project = var.project_id
  region  = var.region
  zone    = var.zone
}

resource "google_bigquery_dataset" "prod_dataset" {
  dataset_id                  = var.ds_prod_name
  friendly_name               = "prod"
  description                 = "This is a prod description"
  location                    = "EU"
  default_table_expiration_ms = 3600000

  labels = {
    env = "default"
  }
}


resource "google_bigquery_dataset" "dev_dataset" {
  dataset_id                  = var.ds_dev_name
  friendly_name               = "dev"
  description                 = "This is a dev description"
  location                    = "EU"
  default_table_expiration_ms = 3600000

  labels = {
    env = "default"
  }
}

resource "google_service_account" "bqowner" {
  account_id = "bqowner"
}


resource "google_bigquery_table" "prod_tb" {
  dataset_id = google_bigquery_dataset.prod_dataset.dataset_id
  table_id   = "bar"

  time_partitioning {
    type = "DAY"
  }

  labels = {
    env = "default"
  }

  schema = file("bq_schema.json")

}


resource "google_bigquery_table" "dev_tb" {
  dataset_id = google_bigquery_dataset.dev_dataset.dataset_id
  table_id   = "sales"

  time_partitioning {
    type = "DAY"
  }

  labels = {
    env = "default"
  }

  schema = file("bq_schema.json")

}

