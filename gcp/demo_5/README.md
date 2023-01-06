# GCP VPC Networks - Controlling Access
 
## Info
https://www.cloudskillsboost.google/focuses/1231?parent=catalog


## Create an nginx web server
```bash
# create 2 nginx vms
vi vm.tf
terraform apply

# ssh connect blue vm
gcloud compute ssh --zone "europe-west1-b" "blue"  --project "yuyatinnefeld-dev"

# edit welcome page (Welcome to nginx! > Welcome blue server!)
sudo nano /var/www/html/index.nginx-debian.html

# verify
cat /var/www/html/index.nginx-debian.html


# ssh connect green vm
gcloud compute ssh --zone "europe-west1-b" "green"  --project "yuyatinnefeld-dev"

# edit welcome page (Welcome to nginx! > Welcome green server!)
sudo nano /var/www/html/index.nginx-debian.html

```

## Create tagged firewall rules
```bash
vi fw_rules.tf
```

## Test Connections
```bash
# check the internal ips
gcloud compute instances list --sort-by=ZONE

gcloud compute ssh --zone "europe-west1-b" "test-vm"  --project "yuyatinnefeld-dev"

# connect with blue and green internal ips
BLUE_INTERNAL_IP=10.0.0.12
curl $BLUE_INTERNAL_IP # WORK
GREEN_INTERNAL_IP=10.0.0.13
curl $GREEN_INTERNAL_IP # WORK


# connect with blue and green external ips
BLUE_EXTERNAL_IP=35.187.70.172
curl $BLUE_EXTERNAL_IP # WORK
GREEN_EXTERNAL_IP=34.140.199.243
curl $GREEN_EXTERNAL_IP # NOT WORK BECAUSE OF FW-RULES

# You are only able to HTTP access the external IP address of the blue server as the allow-http-web-server only applies to VM instances with the web-server tag.
```

## Create a service account with IAM roles
- Network Admin: Permissions to create, modify, and delete networking resources, except for firewall rules and SSL certificates.
- Security Admin: Permissions to create, modify, and delete firewall rules and SSL certificates.
```bash
# ssh connect
gcloud compute ssh --zone "europe-west1-b" "test-vm"  --project "yuyatinnefeld-dev"

# list all firewall rules > permission error
gcloud compute firewall-rules list

# try to delete a firewall-rule > permission error
gcloud compute firewall-rules delete allow-http-web-server

# create a service 
vi service_account.tf

# download the service key and use the service in the vm instance
gcloud auth activate-service-account --key-file credentials.json

# test one more time
gcloud compute firewall-rules list

```