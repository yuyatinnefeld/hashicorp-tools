resource "google_compute_instance" "blue_vm" {
  name                    = "blue"
  machine_type            = "e2-medium"
  zone                    = "europe-west1-b"
  metadata_startup_script = "apt update && apt-get install nginx-light -y"
  
  tags                    = ["web-server"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network    = "default"
    subnetwork = "europe-west1"

    access_config {
      // Ephemeral public IP
    }
  }
}

resource "google_compute_instance" "green_vm" {
  name                    = "green"
  machine_type            = "e2-medium"
  zone                    = "europe-west1-b"
  metadata_startup_script = "apt update && apt-get install nginx-light -y"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network    = "default"
    subnetwork = "europe-west1"

    access_config {
      // Ephemeral public IP
    }
  }
}

resource "google_compute_instance" "test_vm" {
  name                    = "test-vm"
  machine_type            = "f1-micro"
  zone                    = "europe-west1-b"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network    = "default"
    subnetwork = "europe-west1"

    access_config {
      // Ephemeral public IP
    }
  }
}