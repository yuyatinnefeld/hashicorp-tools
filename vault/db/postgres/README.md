# Setup Postgres
```bash

export POSTGRES_CONTAINER=learn-postgres
export PWD=pwd
export USER=root

docker run \
    --detach \
    --name $POSTGRES_CONTAINER \
    -e POSTGRES_USER=$USER \
    -e POSTGRES_PASSWORD=$PWD \
    -p 5432:5432 \
    --rm \
    postgres

# verify
docker ps -f name=$POSTGRES_CONTAINER --format "table {{.Names}}\t{{.Status}}"

# create a role
docker exec -i \
    $POSTGRES_CONTAINER \
    psql -U $USER -c "CREATE ROLE \"ro\" NOINHERIT;"

# grant to read all tables
docker exec -i \
    $POSTGRES_CONTAINER \
    psql -U $USER -c "GRANT SELECT ON ALL TABLES IN SCHEMA public TO \"ro\";"
```

# Setup Vault 

```bash
vault server -dev -dev-root-token-id root
export VAULT_ADDR=http://127.0.0.1:8200
export VAULT_TOKEN=root
export POSTGRES_URL=127.0.0.1:5432

# enable db auth
vault secrets enable database


# configure postgres db
vault write database/config/postgresql \
     plugin_name=postgresql-database-plugin \
     connection_url="postgresql://{{username}}:{{password}}@$POSTGRES_URL/postgres?sslmode=disable" \
     allowed_roles=readonly \
     username="root" \
     password="pwd"

# create SQL script for dynamic secret generation
tee readonly.sql <<EOF
CREATE ROLE "{{name}}" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}' INHERIT;
GRANT ro TO "{{name}}";
EOF

# create dynamic postgres cred
vault write database/roles/readonly \
      db_name=postgresql \
      creation_statements=@readonly.sql \
      default_ttl=1h \
      max_ttl=24h

# verify the creds
vault read database/creds/readonly

# verify the user in postgres
docker exec -i \
    learn-postgres \
    psql -U root -c "SELECT usename, valuntil FROM pg_user;"

#  list existing leases
vault list sys/leases/lookup/database/creds/readonly

LEASE_ID=$(vault list -format=json sys/leases/lookup/database/creds/readonly | jq -r ".[0]")
echo $LEASE_ID

# renew lease
vault lease renew database/creds/readonly/$LEASE_ID

# revoke lease
vault lease revoke database/creds/readonly/$LEASE_ID
```