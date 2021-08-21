provider "aws" {
  profile = "default"
  region  = var.region
}

# 1. create vpc

resource "aws_vpc" "prod_vpc" {
  cidr_block = "10.0.0.0/16"
    tags = {
    Name = "freecodecamp_prod_vpc"
  }
}

# 2. create internet gateway

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.prod_vpc.id

  tags = {
    Name = "freecodecamp_gw"
  }
}

# 3. create custom route table (optional but nice to have)

resource "aws_route_table" "prod-route-tb" {
  vpc_id = aws_vpc.prod_vpc.id

  route = [
    {
      cidr_block = "0.0.0.0/0" #send all traffics to gw
      gateway_id = aws_internet_gateway.gw.id
    },
    {
      ipv6_cidr_block        = "::/0"
      egress_only_gateway_id = aws_internet_gateway.gw.id
    }
  ]

  tags = {
    Name = "freecodecamp_prod_route-tb"
  }
}

# 4. craete a subnet

resource "aws_subnet" "subnet-1" {
  vpc_id            = aws_vpc.prod_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = var.region

  tags = {
    Name = "prod_subnet"
  }
}

# 5. associate subnet with route table

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.prod-route-tb.id
}

# 6. create security group to allow port 22,80, 443

resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow Web inbound traffic"
  vpc_id      = aws_vpc.prod_vpc.id

  ingress = [
    {
      description      = "HTTPS"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = [aws_vpc.prod_vpc.ipv6_cidr_block]
    },
    {
      description      = "HTTP"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = [aws_vpc.prod_vpc.ipv6_cidr_block]
    },
    {
      description      = "SSH"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = [aws_vpc.prod_vpc.ipv6_cidr_block]
    }    
  ]

  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  ]


  tags = {
    Name = "allow_web"
  }
}


resource "aws_vpc_endpoint" "ec2_entpoint" {
  vpc_id       = aws_vpc.prod_vpc.id
  service_name = "com.amazonaws.eu-central-1.ec2"
}


# 7. create a network interface with an ip in the subnet that was created in step4

resource "aws_network_interface" "web_service_yt" {
  subnet_id       = aws_subnet.subnet-1.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.allow_web.id]

}

# 8. assign an elastic ip to the network interface created in step7

resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.web_service_yt.id
  associate_with_private_ip = "10.0.1.50"
  depends_on                = [aws_internet_gateway.gw]
}

# 9. create linux server and install & enable apache2

resource "aws_instance" "web-server-instance" {
  ami               = var.ami
  instance_type     = var.instance_type
  availability_zone = var.region
  key_name          = "tf_key"

  network_interface {
      device_index          = 0
      network_interface_id  = aws_network_interface.web_service_yt.id
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install apache2 -y
              sudo systemctl start apache2
              sudo bash -c 'echo your first web server > /var/www/html/index.html'
              EOF

  tags = {
    Name = var.instance_name
  }
}