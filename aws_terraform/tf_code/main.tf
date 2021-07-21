terraform {
  backend "remote"{
    organization = "yuyatinnefeld"
    workspaces {
      name = "YT-AWS-Workspace"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

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

resource "aws_s3_bucket" "prod_tf"{
  bucket = "tf-yt-learning-20210721"
  acl	 = "private"
}

