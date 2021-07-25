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
  credentials = file("conf/service_account.json")

  project = "terraform-yuya"
  region  = "europe-west3"
  zone    = "europe-west3-b"
}


resource "google_bigquery_dataset" "default" {
  dataset_id                  = "example_terarara_dataset"
  friendly_name               = "test"
  description                 = "This is a test description"
  location                    = "EU"
  default_table_expiration_ms = 3600000

  labels = {
    env = "default"
  }
}

resource "google_service_account" "bqowner" {
  account_id = "bqowner"
}


resource "google_bigquery_table" "default" {
  dataset_id = google_bigquery_dataset.default.dataset_id
  table_id   = "bar"

  time_partitioning {
    type = "DAY"
  }

  labels = {
    env = "default"
  }

  schema = <<EOF
[
  {
    "name": "permalink",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": "The Permalink"
  },
  {
    "name": "state",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": "State where the head office is located"
  }
]
EOF

}

