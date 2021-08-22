# GCP Setup

## Option 1: Use the service account json 

- create a service account
- download and locate this in your project
- define the file path in the main.tf


```bash
provider "google" {
  credentials = file(var.cred)

  ...
```

## Option 2: Login via CLI as Google Account User


### Login GCP
```bash
gcloud version
gcloud auth login
```

### Crearte a service account and mark as Owner

```bash
#!/bin/bash
PROJECT_ID="yyterraform"
REGION="europe-west3"
ZONE="europe-west3-b"
LABEL="terraform"
SERVICE_NAME="developer"
SERVICE_ACCOUNT=${SERVICE_NAME}"@"${PROJECT_ID}".iam.gserviceaccount.com" 
ROLE_NAME="roles/owner"


# CONFIG A GCP PROJECT 
gcloud config set project ${PROJECT_ID}
gcloud config list

# CREATE A SERVICE ACCOUNT
gcloud alpha iam service-accounts create ${SERVICE_NAME}  --display-name="terraform service account"
gcloud alpha iam service-accounts enable  ${SERVICE_ACCOUNT}

gcloud projects add-iam-policy-binding ${PROJECT_ID}  \
    --member="serviceAccount:"${SERVICE_ACCOUNT} \
    --role=${ROLE_NAME}
```