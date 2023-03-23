
### Setup
```bash
# terminal 1 - start dev server
vault server -dev -dev-root-token-id=yt-root-token

# terminal 2 - setup env
export VAULT_ADDR='http://127.0.0.1:8200'
export VAULT_TOKEN=yt-root-token
vault status
```
### Use Default Secrets Engines
```bash
# terminal 2 - create/get/delete a secret
SECRET_NAME="yuya-secret123"
vault kv put secret/${SECRET_NAME} foo=bar foo2=bar2 # create
vault kv get secret/${SECRET_NAME} # get
vault kv put secret/${SECRET_NAME} foo3=bar3 # overwrite
vault kv put secret/yuya-secret567 hello=world # create
vault kv list secret #show all secret
vault kv get -format=json secret/${SECRET_NAME}
vault kv delete secret/yuya-secret567 # delete version
vault kv list secret #show all secret
vault kv get secret/yuya-secret567 # get
vault kv undelete -mount=secret -versions=1 yuya-secret567 # restore

```
### Use Custom Secrets Engines
By default, vault enables a secrets engine called kv at the path "secret/"
You can create a new secret path (e.g. cnk)

```bash
# show enable secrets
vault secrets list

vault secrets enable -path cnk-secret kv
vault secrets disable cnk-secret
vault secrets enable -path cnk kv
vault secrets list

vault kv put cnk/database user=hello-world pass=hi-world
vault kv put cnk/cluster version=123 name=cnk_cluster 
vault kv get cnk/database
vault kv delete cnk/database
vault kv list cnk
vault secrets disable cnk
```

### Dynamic Secrets

```bash
# create aws secret path
vault secrets enable -path aws aws

# add a root user in vault
vault write aws/config/root \
access_key=xxx \
secret_key=yyy \
region=eu-central-1
```

create a role and vault automatically create a user 
```bash
vault write aws/roles/my-role-1234 \
        credential_type=iam_user \
        policy_document=-<<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1426528957000",
      "Effect": "Allow",
      "Action": [
        "ec2:*"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
```

verify the role
```bash
vault read aws/creds/my-role-1234


# revoke
LEASE_ID=aws/creds/my-role-1234/????
vault lease revoke aws/creds/my-role-1234/${LEASE_ID}
```

## Auth
```bash
# display
vault auth list

# enable the GitHub auth method
vault auth enable github
vault write auth/github/config organization=hashicorp
vault write auth/github/map/teams/engineering value=default,applications

vault login -method=github
```
