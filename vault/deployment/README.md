# Vault in Production

## Deploy GCE-instance for Vault

### Offical Solution
https://registry.terraform.io/modules/terraform-google-modules/vault/google/latest/examples/vault-on-gce

### Quick Way
```bash
export GCE_NAME=vault-server
gcloud compute instances create-with-container ${GCE_NAME} --container-image vault:1.13.1

```



## Deploy EC2-instance for vault
