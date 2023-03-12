resource "google_compute_network" "default_net" {
  name                    = var.vpc_network_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet_0" {
  name                  = "subnet-0"
  ip_cidr_range         = "10.10.160.0/24"
  region                = var.region
  network               = google_compute_network.default_net.id
}

resource "google_compute_firewall" "firewall_dataproc" {
  name                  = "${var.vpc_network_name}-allow-dataproc"
  network               = google_compute_network.default_net.id
  source_ranges         = ["10.0.0.0/9"]
  target_tags           = ["dataproc"]

  allow {
    protocol            = "tcp"
    ports               = ["0-65535"]
  }

  allow {
    protocol            = "udp"
  }
}

resource "google_compute_firewall" "firewall_ssh" {
  name                  = "${var.vpc_network_name}-allow-ssh"
  network               = google_compute_network.default_net.id
  source_ranges         = ["0.0.0.0/0"]
  target_tags           = ["allow-ssh"]

  allow {
    protocol            = "tcp"
    ports               = ["22"]
  }
}

resource "google_compute_firewall" "firewall_http" {
  name                  = "${var.vpc_network_name}-allow-http"
  network               = google_compute_network.default_net.id
  source_ranges         = ["0.0.0.0/0"]
  target_tags           = ["http-server"]

  allow {
    protocol            = "tcp"
    ports               = ["80"]
  }
}

resource "google_compute_firewall" "firewall_https" {
  name                  = "${var.vpc_network_name}-allow-https"
  network               = google_compute_network.default_net.id
  source_ranges         = ["0.0.0.0/0"]
  target_tags           = ["https-server"]

  allow {
    protocol            = "tcp"
    ports               = ["443"]
  }
}

resource "google_compute_firewall" "firewall_internal_traffic" {
  name                  = "${var.vpc_network_name}-allow-internal"
  network               = google_compute_network.default_net.id
  source_ranges         = ["10.90.160.0/24"]
  target_tags           = ["internal"]

  allow {
    protocol            = "all"
  }
}