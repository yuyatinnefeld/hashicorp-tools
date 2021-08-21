# Terraform Cloud

## create this main.tf

```bash
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "eu-central-1"
}

resource "aws_instance" "app_server" {
  ami           = "ami-0a86f18b52e547759"
  instance_type = "t2.micro"

  tags = {
    Name = "ExampleYT-Instance"
  }
}

resource "aws_s3_bucket" "prod_tf" {
  bucket = "tf-yt-learning-20210000"
  acl    = "private"
}
```

## create an terraform cloud account

> https://www.terraform.io/cloud

- define the user name
- define the organization name

## create a new workspace by terraform cloud

- select CLI-driven workflow
- define the workspace name


## update your main.tf

```bash
terraform {
  backend "remote" {
    organization = "<ORGANIZATION NAME>"

    workspaces {
      name = "<WORKSPACE NAME>""
    }
  }
}
```

## login 
```bash
terraform login
```


## terraform run

```bash
terraform init
```

## delete the local state fil
- Now that Terraform has migrated the state file to Terraform Cloud
```bash
rm terraform.tfstate
```

## add aws access key id and secret access key
![GitHub Logo](/images/terraform_aws.png)

Workspace > Variables > Enviroment Variables
- AWS_ACCESS_KEY_ID 
- AWS_SECRET_ACCESS_KEY



```bash
terraform validate
terraform plan
terraform apply
```

