# GCP VPC Network Basics

## Info
- https://www.cloudskillsboost.google/focuses/1230?parent=catalog

## Step 1 Create VPC and Subnets
vi network.tf

## Step 2 Create FW Rules
vi fw-rules.tf

## Step 3 Verify
gcloud compute firewall-rules list --sort-by=NETWORK

## Step 4 Create VM Instances
```bash
# create a bucket
vi storage.tf

# upload a startup-script into the bucket
gsutil cp startup.sh gs://yuyatinnefeld-dev-script

# create vms and deploy
vm.tf

# verify that you have 4 vms
gcloud compute instances list --sort-by=ZONE
```
## Step 5 Check connectivity between VMs

```bash
# ssh connect mynet-us-vm
gcloud compute ssh --zone "us-central1-f" "mynet-us-vm"  --project "yuyatinnefeld-dev"

# connect external ip
export MYNET_EU_EXTERNAL_IP=35.241.143.110
export MANAGEMENTNET_US_EXTERNAL_IP=34.123.130.63

ping -c 3 $MYNET_EU_EXTERNAL_IP
ping -c 3 $MANAGEMENTNET_US_EXTERNAL_IP

# connect internal ip
export MYNET_EU_INTERNAL_IP=10.132.0.2
export MANAGEMENTNET_US_INTERNAL_IP=10.130.0.2

ping -c 3 $MYNET_EU_INTERNAL_IP
ping -c 3 $MANAGEMENTNET_US_INTERNAL_IP # DONT WORK BACAUSE OF DIFFERENT VPC


# ssh connect mynet-eu-vm
gcloud compute ssh --zone "europe-west1-b" "mynet-eu-vm"  --project "yuyatinnefeld-dev"

# connect external ip
export MYNET_US_EXTERNAL_IP=34.123.130.63
export MANAGEMENTNET_US_EXTERNAL_IP=34.123.130.63
ping -c 3 $MYNET_US_EXTERNAL_IP
ping -c 3 $MANAGEMENTNET_US_EXTERNAL_IP


# connect internal ip
export MYNET_US_INTERNAL_IP=10.128.0.2
export MANAGEMENTNET_US_INTERNAL_IP=10.130.0.2

ping -c 3 $MYNET_US_INTERNAL_IP
ping -c 3 $MANAGEMENTNET_US_INTERNAL_IP  # DONT WORK BACAUSE OF DIFFERENT VPC

```

## Step 6 Create a VM with multiple network interfaces
vi multiple-vm.tf

## Step 7 Check connectivity in multiple vm
```bash
# verify the interface details
gcloud compute instances describe vm-appliance --zone=us-central1-f

# ssh connect
gcloud compute ssh --zone us-central1-f "vm-appliance"  --project "yuyatinnefeld-dev"

# show network interface
sudo ifconfig

# ping
export MYNET_US_INTERNAL_IP=10.128.0.2
export MYNET_EU_INTERNAL_IP=10.132.0.2
export MANAGEMENTNET_US_INTERNAL_IP=10.130.0.2
export PRIVATENET_INTETRNAL_IP=172.16.0.2

ping -c 3 $MYNET_US_INTERNAL_IP
ping -c 3 $MYNET_EU_INTERNAL_IP # DONT WORK BECAUSE THIS WAS NOT ADDED
ping -c 3 $MANAGEMENTNET_US_INTERNAL_IP
ping -c 3 $PRIVATENET_INTETRNAL_IP

```

## Step 8 Clean up
terraform destroy
