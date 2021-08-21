variable "aws_access_key" {}

variable "aws_secret_key" {}

variable "ssh_key_name" {}

variable "private_key_path" {}

variable "region" {
  default = "eu-central-1"
}

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.region
}

resource "aws_instance" "app_server" {
  ami           = "ami-0a86f18b52e547759"
  instance_type = "t2.micro"

  tags = {
    Name = "ExampleYT-Instance"
  }
}

resource "aws_s3_bucket" "prod_tf"{
  bucket = "tf-yt-learning-20210721"
  acl	 = "private"
}