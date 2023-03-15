
## Deploy Vault

```bash
# create vault setup
vi config.hcl

# deactivate token
unset VAULT_TOKEN

# setup storage location
mkdir -p ./storage-data

# deploy
vault server -config=config.hcl

# initialize the vault
export VAULT_ADDR='http://127.0.0.1:8200'

# initiaze unseal keys
vault operator init
export VAULT_TOKEN="hvs.xxxx"

# oepn ui and copy-paste 3unseal-keys + root-token
open 'http://127.0.0.1:8200'
```

## Sealing / Unsealing
```bash
# recreate unseal keys
# key-shared = count of unseal keys
# threshold = count of input unseal keys for login
vault operator rekey -init -key-shares=6 -key-threshold=2
vault operator rekey

# unsealing = process to make master key
vault operator unseal
```