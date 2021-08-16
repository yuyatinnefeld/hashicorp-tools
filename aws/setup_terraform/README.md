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
provider "aws" {
  profile = "default"
  region = "eu-central-1"
}

resource "aws_s3_bucket" "tf_course" {
  bucket = "tf-yuya-20210717"
  acl = "private"
}
```

## terraform config start
```bash
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

## launch the terraform aws setup
```bash
terraform plan
terraform apply
```


```bash
....
Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

```

### delete the project
```bash
terraform destroy
```

## define the input variable
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

## change the main.tf with the the parameter

```bash
tags = {
  Name = var.instance_name
}
``` 