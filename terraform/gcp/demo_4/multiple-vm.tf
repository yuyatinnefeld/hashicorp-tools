resource "google_compute_instance" "vm_appliance" {
  name         = "vm-appliance"
  machine_type = "n1-standard-4"
  zone         = "us-central1-f"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.privatenet_subnet_1.name
  }
  network_interface {
    subnetwork = google_compute_subnetwork.management_subnet_1.name
  }

  network_interface {
    subnetwork = google_compute_subnetwork.mynetwork_subnet_1.name
  }

}