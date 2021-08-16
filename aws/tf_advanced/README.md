## Terraform without Remote


## Setup

create a terraform.tfvars file
```bash
vi terraform.tfvars
```

```bash
aws_access_key="xxxxxxxxxxxxxx"

aws_secret_key="xxxxxxxxxxxxxx"

ssh_key_name="/.aws/credentials"

private_key_path="/aws_terraform/.aws/xxx.pem"

```


create a main.tf
```bash
vi main.tf
```


```bash
variable "aws_access_key" {}

variable "aws_secret_key" {}

variable "ssh_key_name" {}

variable "private_key_path" {}

variable "region" {
  default = "eu-central-1"
}

variable "vpc_cdir" {
  default = "172.16.0.0/16"
}

variable "subnet1_cidr" {
  default = "172.16.0.0/24"
}

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.region
}

resource "aws_s3_bucket" "prod_tf"{
  bucket = "tf-yt-learning-20210721"
  acl	 = "private"
}
```


configure terraform
```bash
terraform init
```

run terraform
```bash
# plan
terraform plan -var-file=terraform.tfvars
# launch
terraform apply -var-file=terraform.tfvars
# remove
terraform apply -var-file=terraform.tfvars
```
