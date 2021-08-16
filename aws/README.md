# AWS + Terraform

## Info
- https://learn.hashicorp.com/tutorials/terraform/install-cli
- https://learn.hashicorp.com/tutorials/terraform/infrastructure-as-code?in=terraform/aws-get-started


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

## AWS Setup

[Details](https://github.com/yuyatinnefeld/terraform/tree/master/aws/setup_aws)



## Terraform Setup 

[Details](https://github.com/yuyatinnefeld/terraform/tree/master/aws/setup_terraform)
