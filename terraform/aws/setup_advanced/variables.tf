variable "aws_access_key" {}

variable "aws_secret_key" {}

variable "ssh_key_name" {}

variable "private_key_path" {}

variable "region" {
  default = "eu-central-1"
}

variable "vpc_cdir" {
  default = "172.16.0.0/16"
}

variable "subnet1_cidr" {
  default = "172.16.0.0/24"
}
