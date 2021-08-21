# Terraform Setup

## create terraform_dir   

```bash
mkdir tf_code
cd tf_code
```

## create terraform code
```bash
vi main.tf
```

### create a s3 bucket

```bash
provider "aws" {
  access_key = "xxxxxxx"
  secret_key = "yyyyyyy"
  region     = "zzzzzzz"
}

resource "aws_s3_bucket" "prod_tf"{
  bucket = "tf-yt-learning-20210721"
  acl	 = "private"
}
```

## terraform config start
```bash
terraform init
```

## launch the terraform aws setup
```bash
# check the configuration plan
terraform plan

# validate the configuration
terraform validate

# apply the configuration
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

## Terraform Variable, Output Setup

[Details](https://github.com/yuyatinnefeld/terraform/tree/master/aws/setup_terraform/varible_outputs)


## Terraform Cloud Setup

[Details](https://github.com/yuyatinnefeld/terraform/tree/master/aws/setup_terraform/cloud)
