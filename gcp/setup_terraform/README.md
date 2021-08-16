# Terraform Setup

## create terraform_dir   

```bash
mkdir tf_code
```

## create terraform code
```bash
vim first_code.tf
```

```bash
terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "google" {
  credentials = file("<NAME>.json")

  project = "<PROJECT_ID>"
  region  = "europe-west3"
  zone    = "europe-west3-b"
}

resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}
```

## terraform migrate

```bash
terraform init
```
## delete the local state file
```bash
rm terraform.tfstate
```

## terraform apply

```bash
terraform apply
```

Running Terraform on your workstation.
If you are using terraform on your workstation, you will need to install the Google Cloud SDK and authenticate using User Application Default Credentials.
User ADCs do expire and you can refresh them by running:

```bash
gcloud auth application-default login
```



## Terraform Cloud

### create organization by terraform cloud

### login terraform cloud

```bash
terraform login
```
### update main.tf

```bash
terraform {

  backend "remote" {
    organization = "yuyatinnefeld"

    workspaces {
      name = "YT-Workspace"
    }
  }
```
