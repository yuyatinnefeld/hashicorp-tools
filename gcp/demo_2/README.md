# How dynamic backend backet setup
```bash
export ENVIRONMENT="dev"
sed -i ".bak" "s/ENVIRONMENT/$ENVIRONMENT/g" backend.tf 
terraform plan -var "environment=$ENVIRONMENT"
```