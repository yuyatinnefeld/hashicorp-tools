# How to preparate HashiCorp Certified Vault Associate

## Reference
- https://developer.hashicorp.com/vault/tutorials/associate-cert/associate-study
- https://developer.hashicorp.com/vault/tutorials/associate-cert/associate-questions
- https://developer.hashicorp.com/vault/tutorials/associate-cert/associate-review
- https://developer.hashicorp.com/vault/docs/concepts
- https://developer.hashicorp.com/vault/tutorials/tokens
- https://www.udemy.com/course/hashicorp-vault/

## Quick Start Vault Server
```bash
vault server -dev -dev-root-token-id root
export VAULT_ADDR=http://127.0.0.1:8200
# login option 1
export VAULT_TOKEN=root

# login option 2
vault login root
```

## Configure Env variables
```bash

# create env file
cat <<EOT >> vault.env
export VAULT_ADDR=http://localhost:8200
export VAULT_TOKEN=root
EOT

# active env vars
source vault.env
```

## Exam Objectives

## 1. Auth methods
- Auth Methods are responsible for authentication and identity management (policies)
- The token auth method is responsible for creating and storing token
- The fundamental goal of all auth mehtods is to obtain a token
- Each Token has an asssociated policy and a TTL
- The default TOKEN auth method can NOT be disabled but another auth methods can be enabled/disabled using the CLI or the API.
- There are 2 auth methods: human-based and system-based
- The human-based auth methods are i.e. LDAP, OIDC, Github, Okta, userpass
- The system-based auth methods are i.e. Token, TLS, k8s, AWS, Azure, GCP, AppRole
- Cubbyhole and Active Directory are NOT supported auth methods
- The jwt auth method can be used to authenticate with Vault using OIDC or by providing a JWT (e.g. kubernetes)
- entity and alias are used identity serets engine
- An entity can be manually created to map multiple entities as alias (e.g. a user has LDAP, Github, UserPass access and different permissions)

#### Basic Commands
```bash
# activate auth method e.g. userpass (-path is optional)
vault auth enable -path=userpass userpass

# option B
vault write sys/auth/userpass type=userpass

# list up all auth
vault auth list

# create user
export USER_1=yuy.tinn_1
export PASSWORD_1=superpwd
export USER_2=yuy.tinn_2
export PASSWORD_2=superpwd
vault write auth/userpass/users/${USER_1} password=${PASSWORD_1} policies=policy1,policy2
vault write auth/userpass/users/${USER_2} password=${PASSWORD_2} policies=policy1,policy2

# login with the user
vault login -method=userpass username=${USER_1}  password=${PASSWORD_1} 

# list users
vault list auth/userpass/users

```
## 2. Policies
- These 2 default policies 'root' and 'default'
- Declarative rules for deny and grant access to paths
- Deny by default (no policy = no permission)
- Root policy permits access to all components
- Capabilities can be used in a policy (CRUD) + patch, list, sudo, deny
- There are root-protected paths (e.g. sys/ auth/, identity/, secret/, etc.)

```bash
# list policies
vault policy list

# create an admin policy with HCL file
vault policy write yu-admin admin-policy.hcl

# show deteils of a policy
vault policy read yu-admin

# list policies
vault read sys/policy

# check token capabilities
ADMIN_TOKEN=$(vault token create -format=json -policy="yu-admin" | jq -r ".auth.client_token")
echo $ADMIN_TOKEN
vault token capabilities $ADMIN_TOKEN sys/auth/approle
vault token capabilities $ADMIN_TOKEN sys/policies/acl/*
vault token capabilities $ADMIN_TOKEN sys/policies/acl

```

## 3. Token
- Tokens are the core method for authentication within Vault
- There are only 3 ways to create root token: 1. `vault operator init`, 2. By using another root token, 3. `vault operator generate-root`
- Metadata of token determines policies, ttl, max-ttl, type of token
- There are 3 types of token: service-token start with `hvs.xxx` or batch-token with `hvb.xxx` and recovery-token with `hvr.xxx` 
- Service-Token is e.g. root-token, periodic-token, orphan-token, cidr-token
- Batch tokens are designed to improve the performance of applications that need to access multiple secrets at once by reducing the number of API requests needed.
- Batch tokens have a limited lifetime and are automatically revoked by Vault after a certain period of time
- Service tokens are stored in backend
- Vault does not persist the batch tokens
- Batch Tokens are encrypted binary large objects (blobs)
- Every non-root token has a time-to-live (TTL).  When a token expires, Vault automatically revokes it
- Orphan tokens have no parent Token
- Token Accessors reference to a token which can be used to perform limited actions against the token
- 4 limited actions of token accessors: lookup token properties, lookup the capabilities of a token, renew the token, revokde the token
- Default (lease) TTL in Vault is 768h (hour as default type) / 32 days
- Default TTL (768h) can be changed in Vault's configuration file
- You can change the default ttl in the configureation file with `default_lease_ttl = 24h`
- Batch Token cannot be renewed up to the max TTL
- Periodic tokens have a TTL (validity period), but NOT max TTL and is suitable for long-running app which cannot handle the regeneration. bcs you can renew this token over and over and over
- Root or sudo user can create Periodic Token / Orphan-Token
- Through the token-type in AppRole you can define 'batch' or 'service' token

#### Basic Commands
```bash
# list all tokens
vault list auth/token/accessors

# check the details
vault token lookup -accessor <accessor_id>
vault token lookup -format json -accessor <accessor_id>

# look up the properties of the current token
vault token lookup

# create a token
vault token create

# create a periodic token
vault token create -policy=xxx -period=24h # option 1
vault token create -policy=xxx -ttl=24h -explicit-max-ttl=0 # option 2

# create a use limit token
vault token create -policy=xxx -use-limit=2 

# create a orphan token
vault token create -policy=xxx -orphan

# create a token with limit
vault token create -use-limit=10 -policy="default" -period=24h -format=json \
   | jq -r ".auth.client_token" > periodic_token.txt

# verify token limitation
vault token lookup $(cat periodic_token.txt)

# remove token
vault token revoke $(cat periodic_token.txt)
vault token lookup $(cat periodic_token.txt)

# use approle token
# activate auth
vault auth enable approle

# create a role
vault write auth/approle/role/jenkins policies="jenkins" period="24h"

# create role_id file
vault read -format=json auth/approle/role/jenkins/role-id \
    | jq -r ".data.role_id" > role_id.txt

# create service_id file
vault write -f -format=json auth/approle/role/jenkins/secret-id \
    | jq -r ".data.secret_id" > secret_id.txt

# create a token from approle
vault write auth/approle/login role_id=$(cat role_id.txt) \
     secret_id=$(cat secret_id.txt)

RETURNED_TOKEN=hvs.CAESILgCBG0W6GKplXShqNkIpppPQdZchBCJSOmnweWOVfMDGh4KHGh2cy5UclhXVGVsNndsaXBKZ0RpdW1FMTNmUzk
vault token lookup $RETURNED_TOKEN

# clean up token
unset VAULT_TOKEN

# renew a token
vault token renew

# endpoint of create orphan token
auth/token/create-orphan

# endpoint of remove orphan token
auth/token/revoke-orphan
```

## 4. Vault lease

- Leases are a fundamental concept that refer to the duration of time that a piece of data, such as a secret or token, is valid
- Lease is metadata containing information such as a time duration, renewability, and more
- With every `dynamic secret` and `service type` authentication token, Vault creates a lease
- Once the lease is expired, Vault can automatically revoke the data, secrets
- lease_id is used to manage (renew / revoke) the lease of the dynamic secret e.g. `vault lease renew <my-lease-id>` and `vault lease revoke <my-lease-id>`
- Lease in Vault provides a time-limited authorization to access a resource or to generate a dynamic credential

#### Basic Commands
```bash
vault lease lookup database/creds/readonly/xxxx...
vault lease renew database/creds/readonly/xxxx...
vault lease revoke database/creds/readonly/xxxx...

# revoke all AWS access keys
vault lease revoke -prefix aws/

# remove all leases 
vault lease revoke -force xxxx
```

## 5. Secrets Engine
- Secrets engines are components which store, generate, or encrypt data and plugin that extend the functionality
- Secrets engines are enabled and isolated at a path in Vault
- Cubbyhole and Identity are enabled by default and can NOT disable
- Most secrets engines can be enabled, disabled, tuned, and moved via the CLI or API. `vault secrets enable aws`
- There are static secrets (never expire) and dynamic secrets (generated when you need them)
- Dynamic Secrets are often used: CICD pipeline Access to Cloud Provider, Database Creds, Account for Vulnerablitiy Scanning (Cyberark)
- The KV secrets engine is the ONLY secrets engine that can actually store credentials in Vault
- KV v1 endpoint KV `secret/key_path` and v2 endpoint `secret/data/key_path`
- KV v2 can store version of secrets and has metadata
- You can upgrade kv-v1 to kv-v2 with `vault kv enable-versioning xxx/xxx`

#### Basic Commands
```bash
# list all secret engine
vault secrets list

# enable kv se with v1
vault secrets enable -path="kv" kv

# enable kv se with v2
vault secrets enable -path="kv" kv-v2

# create secrets
vault kv put -mount=secret devops/gce password=super_password
vault kv put -mount=secret devops/run password=super_password_1

# list all secrets
vault kv list secret/
vault kv list secret/devops

# get a secret
vault kv get secret/devops/gce
vault kv get secret/devops/run

# check the kv version type
vault secret list -detailed

# fetch data
vault kv get secret/data/xxx # kv v1
vault kv get secret/xxx # kv v2

# create a new kv secret engine
vault secrets enable -path=yu_dev kv
vault kv put -mount=yu_dev devops/gce password=super_password
vault kv list yu_dev/
vault kv get yu_dev/devops/gce

# activte se
vault secrets enable database

# update se
vault secrets tune -max-lease-ttl=30m database

# delete se
vault secrets disable database

```

## 6. Vault CLI
#### Basic Commands
```bash
# Authenticate to Vault
see the chapter 'Quick Start Vault Server'

# Configure authentication methods
see the chapter '1. Authentification methods'

# Configure Vault policies
see the chapter '2. Policies'

# Access Vault secrets
see the chapter '5. Secrets Engine'

# Enable Secret engines
see the chapter '5. Secrets Engine'

# Configure environment variables
see the chapter 'Configure Env variables'
  
```

## 7. Web UI
- if you use config file you need enable ui conf variable `ui = true`


```bash
# create config file
tee config.hcl <<EOF
ui = true
disable_mlock = true

storage "raft" {
  path    = "./vault/data"
  node_id = "node1"
}

listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = "true"
}

api_addr = "http://127.0.0.1:8200"
cluster_addr = "https://127.0.0.1:8201"
EOF

# create backend dir
mkdir -p vault/data

# run vault server
vault server -config=config.hcl

```

## 8. HTTP API
- All API routes are prefixed with `/v1/`
- The API is expected to be accessed over a TLS connection at all times, with a valid certificate
- The client token must be sent as either the `X-Vault-Token:{token}` or `Authorization: Bearer {token}`
- You need to use two prefiex `metadata` and `data` for kv v2 secrets engine for API

#### Basic Commands

```bash
# create kv v1 engine
curl \
    --header "X-Vault-Token: $VAULT_TOKEN" \
    --request POST \
    --data '{"type": "kv-v1"}' \
    http://127.0.0.1:8200/v1/sys/mounts/kv-v1

# save a secret into kv-v1 engine
curl \
  -H "X-Vault-Token: $VAULT_TOKEN" \
  -H "Content-Type: application/json" \
  -X POST \
  -d '{"data":{"value":"bar"}}' \
  http://127.0.0.1:8200/v1/kv-v1/key-for-se-v1

# list all secrets
curl \
    -H "X-Vault-Token: $VAULT_TOKEN" \
    -X LIST \
    http://127.0.0.1:8200/v1/kv-v1/

# create kv v2 engine
curl \
    --header "X-Vault-Token: $VAULT_TOKEN" \
    --request POST \
    --data '{"type": "kv-v2"}' \
    http://127.0.0.1:8200/v1/sys/mounts/kv-v2

curl \
  -H "X-Vault-Token: $VAULT_TOKEN" \
  -H "Content-Type: application/json" \
  -X POST \
  -d '{"data":{"value":"bar"}}' \
  http://127.0.0.1:8200/v1/kv-v2/data/key-for-se-v2-111

curl \
  -H "X-Vault-Token: $VAULT_TOKEN" \
  -H "Content-Type: application/json" \
  -X POST \
  -d '{"data":{"value":"bar"}}' \
  http://127.0.0.1:8200/v1/kv-v2/data/key-for-se-v2-222

curl \
    -H "X-Vault-Token: $VAULT_TOKEN" \
    -X LIST \
    http://127.0.0.1:8200/v1/kv-v2/metadata

### namespace is just for enterprise

# kv2 use namespace option 1
curl \
  --header "X-Vault-Token:$VAULT_TOKEN" \
  -request GET \
  http://127.0.0.1:8200/v1/<NAME-SPACE>/secret/data/xxxx

# kv2 use namespace option 1
curl \
  --header "X-Vault-TOken:$VAULT_TOKEN" \
  --header "X-Vault-Namespace:kv-2" \
  -request GET \
  http://127.0.0.1:8200/v1/data/key-for-se-v2-222

# authenticate to Vault via Curl
curl -H "X-Vault-Token: $VAULT_TOKEN" -X LIST http://127.0.0.1:8200/v1/secret/

# access Vault secrets via Curl
curl -H "X-Vault-Token: $VAULT_TOKEN" -X GET http://127.0.0.1:8200/v1/secret/hello-test
```

## 9. Vault architecture
- Vault’s encryption layer, referred to as the barrier, is responsible for encrypting and decrypting Vault data
- Data is written encrpted into the storage backend (file system, in-memory, cloud-based services, and databases such as MySQL, PostgreSQL, and Cassandra)
- File System are easy to setup, Cloud-based backends provide HA and scalability, DB provides strong consistency and durability.
- When a Vault server is started, it begins in a sealed state. Before any operation can be performed on Vault, it must be unsealed
- The unseal process is done by running vault operator unseal or via the API
- via API  `curl http://.../v1/sys/unseal --request ...`
- Auto Unseal: the seal provider (HSM or cloud KMS) must be available throughout Vault's runtime and not just during the unseal process
- If vault has sealed state then the master key is encrypted and locked
- The master key is used to decrypt the encryption key > Encyption key can unencrypt the data on the storage backend
- `vault operator init` is the process by which Vault's storage backend is prepared to receive data. Vault generates an in-memory master key and applies shamirs secret sharing algorithm
- Policies are just a named ACL rule
- Client token is used for authentication of users
- Policies are used to authorization of requests
- Replication: In HA mode, Vault is deployed in a cluster of multiple servers (one as active primary node and the others as standby nodes)
- MFA, replication, namespaces, DR, HSM auto-unseal can be used only for Vault Enterprise version 
- Vault Agent is a client daemon, which provides auto-auth, api-proxy, caching, windows-service, templating
- Vault Agent Caching (secrets caching) allows client-side caching of responses (new created tokens and secrets)
- Client can be mapped as entities
- Auth provider Accounts (e.g. LDAP and Github) can be mapped as aliases
- Groups, on the other hand, are collections of entities
- Group can have 0-n Entities, Entities can have 0-n Aliases
- Response wrapping allows users to perform an action and receive a wrapped response token instead of an immediate response
- Warpping response has the following benefits: limit the time of secret exposure, only the reference to the secrets in transmitted
- Dynamic secrets are generated on-demand. They are not stored or managed for an extended period, which significantly reduces the risk of exposure to malicious actors
- `period=xxh` is used to set a fixed duration for the token's TTL. This means that the token will be automatically renewed every period duration until it is revoked or expires
- Revoking a lease does not delete the actual secret data, but it prevents any further access to it
- The PKI (Public Key Infrastructure) secret engine provides management of X.509 certificates, PKI allows for the secure storage of private keys, PKI automates certificate issuance and renewal
- you can define 'sealType', 'storage backend', 'cluster name' in the configuration file
- Telemetry: metrics, Logs (memory and CPU usage): event actions
- Cubbyhole provides a personal secret storage space for each authenticated user
- Cubbyhole secret engine is a default secrets engine which is only accessible to the token that writes to it
- TOTP (Time-Based One-Time Password) secret engine is one-time passwords for MFA (two-factor authentication)
- Plugins allows businesses to extend its functionality with solutions written by third-party providers
- WAL stands for "Write-Ahead Log"
- Active Directory secrets engine = secrets engine provides dynamic secrets generation for Microsoft Active Directory
- Namespace allows "vault within a vault" architect
- 8200: UI TCP
- 8201: Cluster Replication TCP
- 8300: Server RPC
- 8301: LAN 
- 8500: Consul Interface
- 8600: Consul DNS
- Update/restart of vault server `vault operator step-down`
- HashiCorp tech provides support of Consul, Filesystem, In-Memory and Raft backend
- You can export encyption-key if the exportable flag is set as true.
- Only In-memory, Raft, Filesystem, Consule are supported Storage Backend by Vault
- `vault operator rekey` command creates new unseal/recovery keys as well as a new master key

### Replication
- DR Replication: Disaster Recovery (DR) replication is used for disaster recovery scenarios when the primary data center goes offline or is otherwise inaccessible.
- Performance Replication: Performance replication allows for high-availability across multiple datacenters by replicating data in real-time. This helps in reducing the latency and improving the performance of the system.
- Global Replication: Global replication is used to keep data in sync between multiple data centers that are geographically dispersed. It helps in providing high availability and disaster recovery.
- Regional Replication: Regional replication is used to replicate data between data centers within the same geographic region. It helps in providing faster access to data and reduced latency.
- Multi-Datacenter Replication: Multi-Datacenter replication is a combination of regional and global replication. It helps in providing high availability, disaster recovery, and faster access to data.
- Integrated Storage is a built-in / INTERNAL solution that provides a highly available, durable storage backend without relying on any external systems
- Integrated Storage uses the same underlying consensus protocol (RAFT) as Consul to handle cluster leadership and log management
- Design Goals of Replication: HA, Conflict Free, Transparent to Clients, Simple to Operate
- Replication uses this to maintain a Write-Ahead-Log (WAL) of all updates, so that the key update happens atomically with the WAL entry creation.
- Data location of Raft = DISK, Consul = MEMORY
##### Auto Join
```bash
storage "raft" {
  path    = "/var/raft/"
  node_id = "node3"

  retry_join {
    auto_join = "provider=aws region=eu-west-1 tag_key=vault tag_value=... access_key_id=... secret_access_key=..."
  }
}
```

##### Retry Join

```bash
storage "raft" {
  path    = "/var/raft/"
  node_id = "node3"

  retry_join {
    leader_api_addr = "https://node1.vault.local:8200"
  }
  retry_join {
    leader_api_addr = "https://node2.vault.local:8200"
  }
}
```

```bash
# manually join
vault operator raf join https://<active_node>.example.com:8200

# list the cluster member of raft nodes
vault operator raft list-peers

# remove peering
vault operator raft remove-peer node1
```


## 10. Encryption as a service (transit SE)
- Transit SE provides functions for encrypting/decrypting data
- Application can send cleartext data to Vault and Vault encrypts using the specified key and return ciphertext to the app
- The App NEVER has access to the encryption key (stored in Vault)
- Only Transform and Transit SE can encrypt and decrypt data
- Transit SE does NOT store the data
- You can manage all your encryption keys and policies in one place
- The datakey in the Transit Secrets Engine is a randomly generated encryption key
- Transit is used for data at rest, while Transform is used for data-in-motion
- All plaintext data must be base64-encoded by Transit SE
- base64-encoding is NOT encryption and is just for the file format to make able to use Transit SE
- `min_decryption_version` is a configuration parameter in Transit SE that specifies the minimum version of ciphertext allowed to be decrypted data
- Apps which use Transit SE need to have permission to use the key for encyption / decryption operation
- your data is encrypted with AES-GCM with a 256-bit AES key or other supported key types
- Transit SE supports convertion encryption mode so that the result (ciphertext) is every time same if the same data is encrypted to make searching of ciphertext easier
- Key rotation is the process of retiring an encryption key and replacing it with a new encryption key, Encryption keys are not infinite
- You can rote keys manually, auto-rotation of vault or external automated process
- aes256-gcm96 is default encryption key type

```bash
# configure transit secret engine
vault secrets enable transit

# create encryption key
vault write -f transit/keys/my-key

# encode data
PLAIN_TEXT=$(base64 <<< "my secret data")
echo ${PLAIN_TEXT}

# encrypt data
vault write transit/encrypt/my-key plaintext=${PLAIN_TEXT}

# decrypt data
export CIPHER_TEXT=vault:v1:7tVAOSAWKnEdawRBQY0FenFuOkU9IJ7yplLcTojkNHt82kJomNBJ1QcRYQ==
vault write transit/decrypt/my-key ciphertext=${CIPHER_TEXT}

# read the file
base64 --decode <<< "bXkgc2VjcmV0IGRhdGEK"

# rotate the encryption key to replace an existing encryption key with a new key
vault write -f transit/keys/my-key/rotate

# verify
vault read transit/keys/my-key

# update with min decryption version
vault write transit/keys/my-key/config min_decryption_version=2
vault read transit/keys/my-key

# re-encrypt original data with the new version
vault write transit/rewrap/my-key ciphertext=<old-data>
```
