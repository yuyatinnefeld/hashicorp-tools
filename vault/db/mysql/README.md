# Create Tables via Vault

## Run Vault Server

```bash
# setup vault
export VAULT_ADDR="http://127.0.0.1:8200"
vault server -dev
export VAULT_TOKEN="hvs.xxxx"
vault status

# add database accessor
vault secrets list
vault secrets enable -path=database database
vault secrets list

```

## Setup MySQL DB

```bash
export DB_PWD="rooooot"
export DB_USER="root"
docker run --name mysql -e MYSQL_ROOT_PASSWORD=${DB_PWD} -p 3306:3306 -d mysql:5.7.22
docker exec -it mysql bin/bash

mysql -u root -prooooot -h127.0.0.1
mysql> create database sample_vault;
Query OK, 1 row affected (0.01 sec)
mysql> use sample_vault;
mysql> create table products (id int, name varchar(50), price varchar(50));
Query OK, 0 rows affected (0.01 sec)
mysql> insert into products (id, name, price) values (1, "Terraform", "1580");
Query OK, 1 row affected (0.00 sec)
mysql> select * from products;
exit
```

## Connect Vault to MySQL

```bash
export CONN_URL="${DB_USER}:${DB_PWD}@tcp(127.0.0.1:3306)/"
export CONN_NAME="vault-mysql-db"
export ROLE_NAME="role-vault-sample"

vault write database/config/${CONN_NAME} \
  plugin_name=mysql-database-plugin \
  connection_url=${CONN_URL} \
  allowed_roles=${ROLE_NAME}
```

## Create Role to generate vault user
```bash
vault write database/roles/${ROLE_NAME} \
  db_name=${CONN_NAME} \
  creation_statements="CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}';GRANT SELECT ON sample_vault.products TO '{{name}}'@'%';" \
  default_ttl="520s" \
  max_ttl="380s"

vault list database/roles

# get username and password
vault read database/creds/role-vault-sample

```

## Access MySQL with Vault DB User 
```bash
docker exec -it mysql bin/bash

mysql -u v-root-role-vault-XXXXXX -pYYYYY -h127.0.0.1
show databases;
select * from products;

# you will get error because this user can only read data
insert into products (id, name, price) values (2,"Vault", "2000");
create table users;
```