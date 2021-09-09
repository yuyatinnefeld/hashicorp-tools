# Terraform

Terraform allows infrastructure to be expressed as code in a simple, human readable language called HCL (HashiCorp Configuration Language). It reads configuration files and provides an execution plan of changes, which can be reviewed for safety and then applied and provisioned. 

## Install Terraform (Linux):

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

## Docker + Terraform

[Details](https://github.com/yuyatinnefeld/terraform/tree/master/docker)


## AWS + Terraform

[Details](https://github.com/yuyatinnefeld/terraform/tree/master/aws)


## GCP + Terraform

[Details](https://github.com/yuyatinnefeld/terraform/tree/master/gcp)


## Snowflake + Terraform

[Details](https://github.com/yuyatinnefeld/terraform/tree/master/snowflake)


## Snowflake + Terraform + Github Actions

[Details](https://github.com/yuyatinnefeld/terraform/tree/master/snowflake/github_cicd)