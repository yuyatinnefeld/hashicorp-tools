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
  default     = "freecodecamp_web_server"
}
