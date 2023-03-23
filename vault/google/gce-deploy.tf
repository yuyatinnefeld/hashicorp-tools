resource "google_kms_key_ring" "vault_keyring" {
  name     = "keyring-vault"
  location = "global"
}

resource "google_kms_crypto_key" "vault_key" {
  name            = "crypto-key-vault"
  key_ring        = google_kms_key_ring.vault_keyring.id
  rotation_period = "100000s"

  lifecycle {
    prevent_destroy = true
  }
}

module "vault" {
  source         = "terraform-google-modules/vault/google"
  project_id     = var.project_id
  region         = var.region
  kms_keyring    = "keyring-vault"
  kms_crypto_key = "crypto-key-vault"
  depends_on = [
    google_kms_key_ring,
    google_kms_crypto_key
  ]
}
