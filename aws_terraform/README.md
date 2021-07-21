# AWS + Terraform

## Info
- https://learn.hashicorp.com/tutorials/terraform/install-cli
-https://learn.hashicorp.com/tutorials/terraform/infrastructure-as-code?in=terraform/aws-get-started


## Install Terraform:

```bash
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform
```

check:
```bash
terraform -help
```

## AWS setup 1
1. create a terraform user with the AdministrationAccess
2. download the credentials.csv
3. save the credentials.csv in your project

4. create 2 directories

```bash
cd aws
mkdir .aws
mkdir terraform_aws
```

5. move the credentials
```bash
mv user_credentials.csv .aws/user_credentials
```

6. reformat the credentials

```bash
vim user_credentials
```

```bash
[default]
aws_access_key_id=yyyyyyyyyyyyy
aws_secret_access_key=xxxxxxxxxxxx
```

OR

## AWS Setup 2 via aws cli

```bash
aws configure
AWS Acess Key ID XXXXXXXXX
AWS Secret Access Key YYYYYYYYYYYY
```

```bash
aws sts get-caller-identity
```

```bash
aws ec2 create-key-pair --key-name tf_key --query 'KeyMaterial' --output text > tf_key.pem
```


## Terraform Setup 

create terraform_dir   
```bash
mkdir tf_code
```

create terraform code
```bash
vim first_code.tf
```

```bash
provider "aws" {
  profile = "default"
  region = "eu-central-1"
}

resource "aws_s3_bucket" "tf_course" {
  bucket = "tf-yuya-20210717"
  acl = "private"
}
```

terraform config start
```bash
terraform init
```

```bash
Initializing the backend...

Initializing provider plugins...
- Finding latest version of hashicorp/aws...
- Installing hashicorp/aws v3.50.0...
- Installed hashicorp/aws v3.50.0 (signed by HashiCorp)

...
Terraform has been successfully initialized!

...
```

launch the terraform aws setup
```bash
terraform plan
terraform apply
```


```bash
....
Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

```

if you don't need the infrastructure anymore
```bash
terraform destroy
```

define the input variable
```bash
vi variables.tf
```

```bash
variable "instance_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "ExampleAppServerInstance"
}
```

change the main.tf

```bash
tags = {
  Name = var.instance_name
}
``` 


