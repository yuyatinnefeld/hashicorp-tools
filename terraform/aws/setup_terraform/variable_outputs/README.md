# Terraform Cloud

## create the main.tf

```bash

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
  bucket = "tf-yt-learning-20210000"
  acl    = "private"
}
```

## create a variables.tf


```bash
vi variables.tf

variable "region" {
  default = "eu-central-1"
}

variable "ami" {
  default = "ami-0a86f18b52e547759"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "instance_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "ExampleYT-Instance"
}

```


## update the main.tf

```bash
provider "aws" {
  profile = "default"
  region  = var.region
}

resource "aws_instance" "app_server" {
  ami           = var.ami
  instance_type = var.instance_type

  tags = {
    Name = var.instance_name
  }
}
```

## output EC2 instance configuration 

```bash
vi outputs.tf

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.app_server.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.app_server.public_ip
}
```

## apply

```bash
terraform apply
terraform destroy
```

