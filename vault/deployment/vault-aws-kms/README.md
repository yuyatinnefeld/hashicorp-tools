# Vault + AWS auto-unseal with KMS

## Sources:
- https://github.com/hashicorp/vault-guides/blob/master/identity/vault-agent-demo/README.md

## How to guide:
- https://developer.hashicorp.com/vault/tutorials/auto-unseal/autounseal-aws-kms

## Setup

```bash
# create a ec2 key pair 
region: us-east-1
name: keypair

# store this keypair for ssh-conn in this project
keypair.pem
chmod 400 keypair.pem

# setup aws config vars
export AWS_ACCESS_KEY_ID=???
export AWS_SECRET_ACCESS_KEY=???/???


# create resources
terraform init
terraform plan -out learn-vault-aws-kms.plan
terraform apply "learn-vault-aws-kms.plan"

# you will recive the output for ssh
For example:
   ssh -i keypair.pem ubuntu@44.204.110.189


# test the auto-unseal feature
ssh -i keypair.pem ubuntu@44.204.110.189

# setup env
SERVER_INSTANCE_PRIVATE_IP=10.0.101.90
export VAULT_ADDR=http://$SERVER_INSTANCE_PRIVATE_IP:8200

# verify status + seal type
vault status

# login
vault operator init
export VAULT_TOKEN=s.???
vault secrets list


# clean up
terraform destroy
```