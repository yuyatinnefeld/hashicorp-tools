# AWS + Vault

## Setup Vault
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

# create a role
vault write aws/roles/my-role \
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
vault read aws/roles/my-role

# generate a dynamic secret
vault read aws/creds/my-role

```
