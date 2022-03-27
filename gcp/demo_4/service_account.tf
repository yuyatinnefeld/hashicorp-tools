resource "google_service_account" "secrity_network_sa" {
  account_id   = "network-security-admin"
}

resource "google_project_iam_member" "security_admin" {
  project = var.project_id
  role    = "roles/compute.securityAdmin"
  member  = "serviceAccount:${google_service_account.secrity_network_sa.email}"
}


resource "google_project_iam_member" "network_admin" {
  project = var.project_id
  role    = "roles/compute.networkAdmin"
  member  = "serviceAccount:${google_service_account.secrity_network_sa.email}"
}