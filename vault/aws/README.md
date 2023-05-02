# AWS + Vault

## Setup Vault AWS Auth Method
```bash
vault server -dev -dev-root-token-id root

export AWS_ACCESS_KEY_ID=???
export AWS_SECRET_ACCESS_KEY=???/???

# enable aws auth
vault auth enable aws

# enable aws se
vault secrets enable -path=aws aws

# configure the credentials
vault write aws/config/root \
    access_key=??? \
    secret_key=???/??? \
    region=us-east-1

# verify the root creds
vault read aws/config/root
```


## Create EC2 Dynamic Creds
```bash
# create a ec2 role
vault write aws/roles/ec2-role \
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
EOF

# verify
vault read aws/roles/ec2-role

# generate a dynamic secret for ec2 user
vault read aws/creds/ec2-role

# delete the user
LEASE_ID="aws/creds/ec2-role/jWl58nfsLhpSpFbw17i2LED0"
vault lease revoke ${LEASE_ID}
```

## Create EC2 ReadOnly Creds


```bash
vault write aws/roles/readonly-role \
policy_arns=arn:aws:iam::aws:policy/ReadOnlyAccess \
credential_type=iam_user

vault read aws/roles/readonly-role

vault read aws/creds/readonly-role


# delete the user
LEASE_ID="aws/creds/readonly-role/50sUZKCWT3cT9vl3xClWyGCj"
vault lease revoke ${LEASE_ID}
```

## Revoke AWS Creds with Prefix

```bash
# create a few creds
vault read aws/creds/readonly-role
vault read aws/creds/readonly-role
vault read aws/creds/ec2-role
vault read aws/creds/ec2-role

vault lease revoke -prefix aws
vault lease revoke -prefix aws/creds

```