variable "region" {
default = "eu-central-1" # your region
}

variable "instance_type" {
default = "t2.micro"
}

variable "instance_key" {
default = "tf_key" # your keypair
}

variable "vpc_cidr" {
default = "178.0.0.0/16"
}

variable "public_subnet_cidr" {
default = "178.0.10.0/24"
}