# Terragrunt to manage multiple terraform environments

## setup
```bash
# install
brew install terragrunt

# create a main terragrunt file
touch terragrunt.hcl

# create a environment folder and setup terragrunt.htc file
mkdir -p environments/dev
touch environments/dev/terragrunt.hcl

# create a module folder
mkdir module

# initialize terragrunt file
cd environments/dev
terragrunt init

# create resources
terragrunt plan
terragrunt apply

```