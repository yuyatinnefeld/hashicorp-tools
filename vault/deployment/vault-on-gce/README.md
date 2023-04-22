## Set Env

```bash
# Authenticate the local SDK:
gcloud auth application-default login

# Create a new project or use an existing project. Save the ID for use
export GOOGLE_CLOUD_PROJECT=yuyatinnefeld-dev

#Enable the Compute Engine API (Terraform will enable other required ones):

gcloud services enable --project "${GOOGLE_CLOUD_PROJECT}" compute.googleapis.com
gcloud services enable --project "${GOOGLE_CLOUD_PROJECT}" compute.googleapis.com

#Create a terraform.tfvars file in the current working directory with your configuration data:
echo 'project_id = "yuyatinnefeld-dev"' >> terraform.tfvars

```

## Provision GCE VM

```bash
terraform init

terraform plan
var.project
  Enter a value: yuyatinnefeld-dev

var.zone
  Enter a value: europe-west1


terraform apply
var.project
  Enter a value: yuyatinnefeld-dev

var.zone
  Enter a value: europe-west1
```

### Offical Solution
https://registry.terraform.io/modules/terraform-google-modules/vault/google/latest/examples/vault-on-gce

