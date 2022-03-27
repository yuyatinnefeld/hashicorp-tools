resource "google_compute_firewall" "allo_http_web_server" {
  name    = "allow-http-web-server"
  network = "default"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  target_tags = ["web-server"]

  source_ranges = ["0.0.0.0/0"]
}