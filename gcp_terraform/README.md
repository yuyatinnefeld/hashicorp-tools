<h1 align="center">GCP + TERRAFORM</h1> <br>
<h2> 🚀 Table of Contents 🚀 </h2>

- [About](#about)
- [Benefits](#benefits)
- [products](#products)
- [Info](#info)
- [Setup](#setup)

## Info
- https://cloud.google.com/architecture/managing-infrastructure-as-code
- https://registry.terraform.io/providers/hashicorp/google/latest/docs
- https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/bigquery_table
- https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/bigquery_dataset


## GCP native setup

### 1. login by GCP
gcloud_login.sh

### 2. setup GCP Project
gcloud_setup.sh

### 3. setup Terraform
terraform_setup.sh

### 4. connect github + cloud build

> https://cloud.google.com/architecture/managing-infrastructure-as-code

Directly connecting Cloud Build to your GitHub repository

## Terraform setup

- https://learn.hashicorp.com/tutorials/terraform/infrastructure-as-code?in=terraform/gcp-get-started

## Terraform Cloud
- https://learn.hashicorp.com/tutorials/terraform/aws-remote?in=terraform/aws-get-started

1. setup Terraform local

2. create organization by terraform cloud

3. login terraform cloud

```bash
terraform login
```
4. update main.tf

```bash
terraform {

  backend "remote" {
    organization = "yuyatinnefeld"

    workspaces {
      name = "YT-Workspace"
    }
  }
```
5. terraform migrate

```bash
terraform init
```
6. delete the local state file
```bash
rm terraform.tfstate
```

7. run terraform apply

```bash
terraform apply
```

Running Terraform on your workstation.
If you are using terraform on your workstation, you will need to install the Google Cloud SDK and authenticate using User Application Default Credentials.
User ADCs do expire and you can refresh them by running:

```bash
gcloud auth application-default login
```

