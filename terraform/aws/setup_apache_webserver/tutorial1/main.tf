
provider "aws" {
  profile = "default"
  region  = var.region
}


resource "aws_vpc" "prod_vpc" {
  cidr_block = "10.0.0.0/16"
    tags = {
    Name = "production"
  }
}

resource "aws_subnet" "subnet-1" {
  vpc_id     = aws_vpc.prod_vpc.id
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "prod_subnet"
  }
}


resource "aws_vpc" "dev_vpc" {
  cidr_block = "10.1.0.0/16"
    tags = { 
    Name = "development"
  }
}

resource "aws_subnet" "subnet-2" {
  vpc_id     = aws_vpc.dev_vpc.id
  cidr_block = "10.1.1.0/24"

  tags = {
    Name = "dev_subnet"
  }
}