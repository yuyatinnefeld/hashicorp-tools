# Docker + Terraform

## Login GCP

```bash
mkdir tf_code
cd tf_code
vi main.tf
```

## create main.tf
```bash
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.13.0"
    }
  }
}

provider "docker" {}

resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = false
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.latest
  name  = "tutorial"
  ports {
    internal = 80
    external = 8000
  }
}
```

## initialize the project

```bash
terraform init
```

## run terraform 

```bash
# plan 
terraform plan

# validate your configuration
terraform validate

# apply
terraform apply

# check the result
terraform show
```

## verify the existence of the NGINX container by visiting localhost:8000

> localhost:8000


```bash
terraform state list

docker ps
```


## set the container name with a variable

```bash
vi variables.tf


# define the container name 
variable "container_name" {
  description = "Value of the name for the Docker container"
  type        = string
  default     = "ExampleNginxContainer"
}

# update the main.tf
vi main.tf

# rename the container
resource "docker_container" "nginx" {  
  image = docker_image.nginx.latest
  - name  = "tutorial"
  + name  = var.container_name  
  ports {    
    internal = 80    
    external = 8080  
  }
}

# apply the configuration change
terraform apply

```


## delete the container and images

```bash
terraform destory
```