# Terraform

This project is centered on learning Terraform, an infrastructure as code tool. The objective is to gain hands-on experience with Terraform and learn how to use it to manage and automate infrastructure deployment.

Through this project, you will learn how to write Terraform code to provision infrastructure resources on cloud platforms such as AWS, Google Cloud, and Azure. You will also learn how to use Terraform modules and state management to optimize your infrastructure deployment process.

In addition to the technical aspects, this project also covers best practices in infrastructure management, such as version control and collaboration. You will learn how to use Git and GitHub to manage Terraform code and collaborate with team members on infrastructure projects.

This project is designed to be interactive and hands-on, allowing you to apply what you learn through practical exercises and real-world scenarios. Whether you're new to infrastructure as code or looking to expand your existing skills, this project provides the knowledge and hands-on experience needed to be successful with Terraform.

## Getting Started (Linux):

```bash
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform
```

check:
```bash
terraform -help
```

## GCP + Terraform

[Details](https://github.com/yuyatinnefeld/terraform/tree/master/gcp)

## AWS + Terraform

[Details](https://github.com/yuyatinnefeld/terraform/tree/master/aws)

## Snowflake + Terraform

[Details](https://github.com/yuyatinnefeld/terraform/tree/master/snowflake)

## Snowflake + Terraform + Github Actions

[Details](https://github.com/yuyatinnefeld/terraform/tree/master/snowflake/github_cicd)
