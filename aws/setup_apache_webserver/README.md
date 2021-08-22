# Create Apache Web Server in AWS

- https://dev.to/chefgs/create-apache-web-server-in-aws-using-terraform-1fpj

## aws config

```bash
aws config
```

## tutorial 1 - vpc & subnet

```bash
mkdir tutorial12
cd tutorial12
```

```bash
# create a main.tf
vi main.tf

# create a variables.tf
vi variables.tf

# terraform run

# initialize terraform
terraform init
terraform apply --auto-approve
terraform destroy --auto-approve
```

## tutorial 2 - ec2 instance

### steps
0. create keypair.pem
```bash
cd conf
aws ec2 create-key-pair --key-name tf_key --query 'KeyMaterial' --output text > tf_key.pem
```
1. create vpc
2. create internet gateway
3. create custom route table (optional but nice to have)
4. craete a subnet
5. associate subnet with route table
6. create security group to allow port 22,80, 443
7. create a network interface with an ip in the subnet that was created in step4
8. assign an elastic ip to the network interface created in step7
9. create ubuntu server and install & enable apache2


```bash
cd tutorial2
terraform init
terraform plan -var-file=aws.tfvars
terraform apply -var-file=aws.tfvars -auto-approve
# eu-central-1

terraform destroy -var-file=aws.tfvars -auto-approve
```