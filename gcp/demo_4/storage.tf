resource "google_storage_bucket" "auto-expire" {
  name          = "yuyatinnefeld-dev-script"
  location      = "EU"
  force_destroy = true

  lifecycle_rule {
    condition {
      age = 3
    }
    action {
      type = "Delete"
    }
  }
}