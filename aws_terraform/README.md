# AWS + Terraform

## LINUX Setup
- https://learn.hashicorp.com/tutorials/terraform/install-cli
-https://learn.hashicorp.com/tutorials/terraform/infrastructure-as-code?in=terraform/aws-get-started


install:

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

## AWS setup
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

7. create terraform code
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

8. create terraform_dir 
```bash
mkdir terraform_code
```


9. create terraform
```bash
cd terraform_code
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

10. launch the terraform aws setup
```bash
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

11. define the input variable
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


