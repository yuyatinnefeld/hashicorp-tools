provider "vault" {
  address = "http://127.0.0.1:8200"
  token   = var.root_token
}

data "vault_kv_secret_v2" "terraform_sql_db" {
  mount = "terraform-secrets"
  name  = "sql-database"
}

resource "vault_generic_secret" "example_secret" {
  path = "terraform-secrets/example"

  data_json = jsonencode({
    username = "my_username",
    password = "my_password"
  })
}

output "vault_secrets_info_name" {
  value = data.vault_kv_secret_v2.terraform_sql_db.name
}

output "vault_secrets_info_created_time" {
  value = data.vault_kv_secret_v2.terraform_sql_db.created_time
}

output "vault_my_secrets" {
  value = data.vault_kv_secret_v2.terraform_sql_db.data_json
  sensitive = true
}