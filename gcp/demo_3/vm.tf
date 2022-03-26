resource "google_compute_instance" "managementnet_us_vm" {
  name         = "managementnet-us-vm"
  machine_type = "n1-standard-1"
  zone         = "us-central1-f"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.management_subnet_1.name

    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    foo = "bar"
  }

  metadata_startup_script = "echo hi > /test.txt"

}

resource "google_compute_instance" "privatenet_us_vm" {
  name         = "privatenet-us-vm"
  machine_type = "n1-standard-1"
  zone         = "us-central1-f"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.privatenet_subnet_1.name
  }

  metadata = {
    foo = "bar2"
  }

  metadata_startup_script = "gs://yuyatinnefeld-dev-script/startup.sh"
}

resource "google_compute_instance" "mynet_eu_vm" {
  name         = "mynet-eu-vm"
  machine_type = "n1-standard-1"
  zone         = "europe-west1-b"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.mynetwork_subnet_2.name
    access_config { }
  }
}

resource "google_compute_instance" "mynet_us_vm" {
  name         = "mynet-us-vm"
  machine_type = "n1-standard-1"
  zone         = "us-central1-f"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.mynetwork_subnet_1.name
    access_config { }
  }
}