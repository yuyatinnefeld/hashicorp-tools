# AWS Setup

## Option 1 - Create a credentials
1. create a terraform user with the AdministrationAccess
2. download the credentials.csv
3. save the credentials.csv in your project
4. create 2 directories

```bash
cd aws
mkdir .aws
mkdir terraform_aws

# move the credentials into your project repo
mv user_credentials.csv .aws/credentials

# reformat the credentials
vim credentials
```

```bash
[default]
aws_access_key_id=yyyyyyyyyyyyy
aws_secret_access_key=xxxxxxxxxxxx
```


## Option 2 - Create .pem file via CLI

```bash
# navigate into the conf repo
cd conf

# check configure
aws configure


# copy paste the access key id and secret access key
AWS Acess Key ID XXXXXXXXX
AWS Secret Access Key YYYYYYYYYYYY

# returns details about the IAM user or role
aws sts get-caller-identity

# create a keypair pem file
aws ec2 create-key-pair --key-name tf_key --query 'KeyMaterial' --output text > tf_key.pem
```
