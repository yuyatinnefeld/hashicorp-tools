# AWS + Terraform + Github Actions

This guide shows how to build a simple CI/CD pipeline for AWS with GitHub Actions and Terraform

## Setup a new Terraform workspace
1. Login / Register
https://app.terraform.io/app

2. click "New workspace"

3. select "API driven workflow"

4. define the name "AWS-Github"

5. Setup Environment Variables

Variable key
- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY

6. Create an API Token

- Click on the user icon > click on "User settings"
- Click on the user settings page click on the "Tokens"
- Click "Create API token"
- Description: AWS Github Actions
- You need to save the API token

## Create the Actions Workflow

### Create a Actions Secrets
1. Create Github Repo
 
2. Create Actions Secrets
- Click Settings > Secrets > Click on the "New repository secret"
- Name = TF_API_TOKEN 
- Value = Terraform Token

## Define the Action Workflows
In this step we will create a deployment workflow which will run Terraform and deploy changes to the AWS account

- Select the Github Repo > click on the "Actions" > click on the "Set up this workflow"

- Name the workflow = aws-terraform.yml
- In the "Edit new file" box, replace the contents with the the following:
- check if the main branch name "main"

Please note that if you are re-using an existing GitHub repository it might retain the old master branch naming. If so, please update the YAML bottom

```yml
name: "AWS Terraform Demo Workflow"

on:
  push:
    branches:
      - main

jobs:
  aws-terraform:
    name: "AWS Terraform Demo Job"
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v2

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v1
        with:
          cli_config_credentials_token: ${{ secrets.TF_API_TOKEN }}

      - name: Terraform Format
        id: fmt
        run: terraform fmt -check

      - name: Terraform Init
        id: init
        run: terraform init

      - name: Terraform Validate
        id: validate
        run: terraform validate -no-color

      - name: Terraform Apply
        id: apply
        run: terraform apply -auto-approve
```

- Click on the "Start commit"

## Create Your First Database Migration
1. git clone your github repo
```bash
git clone git@github.com:<YOURNAME>/aws-terraform.git
```


2. add a main.tf 
```bash
vi main.tf
```

replace the organization name with your Terraform Cloud organization name
```bash
terraform {
  backend "remote" {
    organization = "yuyatinnefeld"

    workspaces {
      name = "AWS-Github"
    }
  }

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
  bucket = "tf-yt-learning-20210721"
  acl    = "private"
}
```


3. commit and push the change
```bash
git add .
git commit -m "add main.tf"
git push origin main
```
the first database migration should have been successfully deployed

## Confirm changes deployed to snowflake

1. check AWS Objects
2. check Terraform Cloud Log
3. check GitHub Actions Log
