# GCP

## Use GCS Bucket as data storage
```bash
# create a sample bucket
BUCKET_NAME="hello-world-test-vault-12345"
gsutil mb gs://${BUCKET_NAME}

# create vault server
vault server -config=config.hcl

# uneal and login
vault operator init
vault unseal
export VAULT_ADDR='http://127.0.0.1:8200'
export VAULT_TOKEN="<ROOT_TOKEN>"
open 'http://127.0.0.1:8200'

# verify the encypted data
gsutil ls gs://${BUCKET_NAME}/*
```

## Use Dynamic Secrets

```bash
# create a bucket
BUCKET_NAME_2="hello-world-test-vault-999999"
gsutil mb gs://${BUCKET_NAME_2}

# enable gcp secrets engine
vault secrets enable gcp

# create a service account
SA_NAME="vault-sa"
gcloud iam service-accounts create ${SA_NAME}

# grant the service account an IAM viewer role
PROJECT_ID="<YOUR_GCP_PROJECT>"
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member="serviceAccount:${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" \
    --role="roles/editor"

# create a key
SA_KEY="my_creds.json"
gcloud iam service-accounts keys create ${SA_KEY} \
    --iam-account=${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com


# Generate credentials
vault write gcp/config \
credentials=@${SA_KEY} \
 ttl=3600 \
 max_ttl=86400


# configure a roleset that generates OAuth2 access tokens
SA_TOKEN_NAME="my-gpc-sa-token-roleset"

vault write gcp/roleset/${SA_TOKEN_NAME} \
    project=${PROJECT_ID} \
    secret_type="access_token"  \
    token_scopes="https://www.googleapis.com/auth/cloud-platform" \
    bindings=@bindings.hcl

# read token
vault read gcp/roleset/${SA_TOKEN_NAME}/token

# read bucket info
curl \
  'https://storage.googleapis.com/storage/v1/b/hello-world-test-vault-999999' \
  --header 'Authorization: Bearer <OAUTH2_TOKEN>' \
  --header 'Accept: application/json'

# store data into the bucket
echo hello-vault-test >> sample.txt

gsutil cp sample.txt gs://${BUCKET_NAME_2}/sample.txt

curl -X GET \
  -H "Authorization: Bearer OAUTH2_TOKEN" \
  -o "sample.txt" \
  "https://storage.googleapis.com/storage/v1/b/hello-world-test-vault-999999/o/sample.txt?alt=media"
```


# Running Vault in Production

```bash
# deploy vault in GCE
terraform init
terraform apply

#install vault and set path
mkdir temp && cd temp
sudo apt-get update && sudo apt-get upgrade -y
wget https://releases.hashicorp.com/vault/1.13.0/vault_1.13.0_linux_amd64.zip
unzip vault_1.13.0_linux_amd64.zip


# setup paths
mv vault /usr/bin # vault binary
sudo mkdir -p /opt/vault/data # data-store
sudo mkdir -p /etc/vault.d/vault.hcl # vault config
sudo mkdir -p /lib/systemd/system/vault.service #systemd service file
vault version


# deploy Vault in the EC2 Instance

# start
sudo journalctl -u vault


# stop vault
sudo systemctl stop vault

```