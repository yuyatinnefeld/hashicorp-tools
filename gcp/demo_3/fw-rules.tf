resource "google_compute_firewall" "management_fw_rule_1" {
  name    = "managementnet-allow-icmp-ssh-rdp"
  network = google_compute_network.management_network.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "3389"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "privatenet_fw_rule_1" {
  name    = "privatenet-allow-icmp-ssh-rdp"
  network = google_compute_network.private_network.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "3389"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "mynetwork_fw_rule_1" {
  name    = "mynetwork-allow-icmp"
  network = google_compute_network.my_network.name

  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "mynetwork_fw_rule_2" {
  name    = "mynetwork-allow-rdp"
  network = google_compute_network.my_network.name

  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "mynetwork_fw_rule_3" {
  name    = "mynetwork-allow-ssh"
  network = google_compute_network.my_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}