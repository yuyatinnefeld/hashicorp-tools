# Terraform Vault Provider

## Vault Setup
```bash

# create vault user
vault server -dev -dev-root-token-id root
export VAULT_ADDR=http://127.0.0.1:8200
# login option 1
export VAULT_TOKEN=root

# create vault secrets
vault secrets enable -path=terraform-secrets kv-v2
export DB_USER="hello"
export DB_USER_PASSWORD="world"
vault kv put -mount=terraform-secrets sql-database user=${DB_USER} password=${DB_USER_PASSWORD}
vault kv get -mount=terraform-secrets sql-database
```

## Use Vault Secrets in Terraform

```bash
terraform init

terraform apply

terraform output -raw vault_my_secrets

```