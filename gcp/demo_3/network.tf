####### vpc area mynetwork #######

resource "google_compute_network" "my_network" {
  project = var.project_id
  name    = "mynetwork"
  auto_create_subnetworks = false
  mtu     = 1460
}

resource "google_compute_subnetwork" "mynetwork_subnet_1" {
  name          = "mynetwork-subnet-us"
  ip_cidr_range = "10.128.0.0/20"
  region        = "us-central1"
  network       = google_compute_network.my_network.id
}

resource "google_compute_subnetwork" "mynetwork_subnet_2" {
  name          = "mynetwork-subnet-eu"
  ip_cidr_range = "10.132.0.0/20"
  region        = "europe-west1"
  network       = google_compute_network.my_network.id
}

####### vpc area management #######

resource "google_compute_network" "management_network" {
  project = var.project_id
  name    = "management"
  auto_create_subnetworks = false
  mtu     = 1460
}

resource "google_compute_subnetwork" "management_subnet_1" {
  name          = "management-subnet-us"
  ip_cidr_range = "10.130.0.0/20"
  region        = "us-central1"
  network       = google_compute_network.management_network.id
}


####### vpc area privatenet #######

resource "google_compute_network" "private_network" {
  project = var.project_id
  name    = "privatenet"
  auto_create_subnetworks = false
  mtu     = 1460
}

resource "google_compute_subnetwork" "privatenet_subnet_1" {
  name          = "privatenet-subnet-us"
  ip_cidr_range = "172.16.0.0/24"
  region        = "us-central1"
  network       = google_compute_network.private_network.id
}

resource "google_compute_subnetwork" "privatenet_subnet_2" {
  name          = "privatenet-subnet-eu"
  ip_cidr_range = "172.20.0.0/20"
  region        = "europe-west1"
  network       = google_compute_network.private_network.id
}
