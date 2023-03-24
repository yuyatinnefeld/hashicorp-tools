# Authentication

## Run Vault Server
```bash
# terminal 1 - start dev server
vault server -dev -dev-root-token-id=yt-root-token

# terminal 2 - setup env
export VAULT_ADDR='http://127.0.0.1:8200'
export VAULT_TOKEN=yt-root-token
vault status
```
## Setup environment
```bash
# write some secrets
vault kv put secret/specific/test color=blue number=eleventeen
vault kv get secret/specific/test
vault kv put secret/bye-data/test color=red number=123
vault kv get secret/bye-data/test


# create policy
export POLICY_NAME="yt-test-policy"

echo 'path "secret/data/specific/*" {
  capabilities = ["list", "read"]
}' | vault policy write ${POLICY_NAME} -

```

## Auth with UserPass Token
```bash
# enable approle
vault auth enable userpass

# create a user
export USER_NAME="ytchellh"
export USER_PWD="foo"

vault write auth/userpass/users/${USER_NAME} policies=${POLICY_NAME} password=${USER_PWD}

vault login -method=userpass \
    username=${USER_NAME} \
    password=${USER_PWD}
  
# can access
vault kv get secret/hw-data/test

# cannot access
vault kv get secret/bye-data/test
```

## Auth with AppRole Token

```bash
# enable approle
vault auth enable approle

# configure approle role named "yt-test-role"
export ROLE_NAME="yt-test-role"
vault write auth/approle/role/${ROLE_NAME} \
secret_id_bound_cidrs="0.0.0.0/0","127.0.0.1/32" \
secret_id_ttl=60m \
secret_id_num_uses=5 \
enable_local_secret_ids=false \
token_bound_cidrs="0.0.0.0/0","127.0.0.1/32" \
token_num_uses=10 \
token_ttl=1h \
token_max_ttl=3h \
token_type=default \
period="" \
policies="default",${POLICY_NAME}

# Read role-id
vault read auth/approle/role/${ROLE_NAME}/role-id 
ROLE_ID=$(vault read -format=json auth/approle/role/${ROLE_NAME}/role-id | jq -r '.data.role_id')

# generate secret-id
vault write -f auth/approle/role/${ROLE_NAME}/secret-id
SECRET_ID=$(vault write -f -format=json auth/approle/role/${ROLE_NAME}/secret-id | jq -r '.data.secret_id')

OUTPUT=$(vault write auth/approle/login role_id=${ROLE_ID} secret_id=${SECRET_ID})

export VAULT_FORMAT=json
VAULT_TOKEN=$(echo $OUTPUT | jq '.auth.client_token' -j)

# login with the approle token
vault login $VAULT_TOKEN

# can access
vault kv get secret/specific/test

# cannot access
vault kv get secret/bye-data/test
```

## Auth with Github Token
```bash
# enable approle
vault auth enable github

# add github organisation
export ORG_NAME="yuyatinnefeld-org"
vault write auth/github/config organization=${ORG_NAME}
vault read auth/github/config

# add github team
export TEAM_NAME="my-team"
vault write auth/github/map/teams/${TEAM_NAME} value=${POLICY_NAME}
vault read auth/github/map/teams/${TEAM_NAME}

# create github token
# github > settings > developer settings > personal access token > activate admin:org
export GITHUB_TOKEN=ghp_xxx

# loglin with github token
vault login -method=github token=${GITHUB_TOKEN}

# can access
vault kv get secret/hw-data/test

# cannot access
vault kv get secret/bye-data/test

```
## Auth with AWS Token

## Auth with k8s Token
