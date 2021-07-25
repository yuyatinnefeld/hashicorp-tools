/*
terraform {

  backend "remote" {
    organization = "yuyatinnefeld"

    workspaces {
      name = "GCP-yuya-tinnefeld-profile"    
      }
  }
  
  
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
    }
  }
}
*/

provider "google" {
  credentials = file("conf/service_account.json")

  project = "yuya-tinnefeld-profile"
  region  = "europe-west3"
  zone    = "europe-west3-b"
}


// Terraform plugin for creating random ids
resource "random_id" "instance_id" {
 byte_length = 8
}

// A single Compute Engine instance
resource "google_compute_instance" "default" {
 name         = "flask-vm-${random_id.instance_id.hex}"
 machine_type = "f1-micro"
 zone         = "europe-west3-b"

 metadata = {
   ssh-keys = "yt-profiel@yuya-tinnefeld-profile.iam.gserviceaccount.com:${file("~/.ssh/id_rsa.pub")}"
 }

 boot_disk {
   initialize_params {
     image = "debian-cloud/debian-9"
   }
 }

// Make sure flask is installed on all new instances for later steps
 metadata_startup_script = "sudo apt-get update; sudo apt-get install -yq build-essential python-pip rsync; pip install flask"

 network_interface {
   network = "default"

   access_config {
     // Include this section to give the VM an external ip address
   }
 }
}

resource "google_compute_firewall" "default" {
 name    = "flask-app-firewall"
 network = "default"

 allow {
   protocol = "tcp"
   ports    = ["5000"]
 }
}

