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
  zone  = var.zone
}

resource "google_service_account" "gce_sa" {
  account_id   = "compute-engine-sa"
  display_name = "gce_sa"
}

resource "google_compute_instance" "default" {
  name         = "gce-vault"
  machine_type = "n2-standard-2"
  zone         = var.zone

  tags = ["foo", "bar"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        my_label = "value"
      }
    }
  }

  // Local SSD disk
  scratch_disk {
    interface = "SCSI"
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    foo = "bar"
  }

  metadata_startup_script = "echo hi > /test.txt"

  service_account {
    email  = google_service_account.gce_sa.email
    scopes = ["cloud-platform"]
  }
}
