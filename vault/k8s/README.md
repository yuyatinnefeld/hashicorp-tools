# Vault Kubernetes Secrets Engine

## Source: https://developer.hashicorp.com/vault/tutorials/kubernetes/kubernetes-secrets-engine


## Set up Vault on k8s

```bash
# start minikube
minikube start

# add repo
helm repo add hashicorp https://helm.releases.hashicorp.com
helm search repo hashicorp/vault

# deploy vault pods
helm install vault hashicorp/vault -n vault -f values.yaml --create-namespace

# check release
helm list -A -n vault

# verify
kubectl get pods -n vault

# allow access to the Vault instance running in your minikube cluster
kubectl port-forward -n vault service/vault 8200:8200 1> /dev/null &

# setup local env vars
export VAULT_DEV_ROOT_TOKEN_ID="root" \
    VAULT_TOKEN="root" \
    VAULT_ADDR="http://127.0.0.1:8200" \
    KUBE_HOST=$(kubectl config view --minify \
        -o 'jsonpath={.clusters[].cluster.server}')

# create a new ns
kubectl create namespace demo

# create the role, service accounts and bindings 
kubectl apply -f roles.yaml,serviceAccounts.yaml,bindings.yaml

# start nginx server
kubectl run nginx --image=nginx --namespace demo

# verify
kubectl get pods -n demo
```

## Set up k8s Service Engine

```bash
# enable k8s se
vault secrets enable kubernetes

# initialize the k8s plugin
vault write -f kubernetes/config

# create a role
vault write kubernetes/roles/sample-app \
    service_account_name=sample-app \
    allowed_kubernetes_namespaces=demo \
    token_max_ttl=80h \
    token_default_ttl=1h

# create creds
vault write kubernetes/creds/sample-app kubernetes_namespace=demo

export SERVICE_TOKEN=eyJhbGciOiJS....

export TEST_TOKEN=$SERVICE_TOKEN
```

## Demo with token
```bash
# examine the payload of the JWT.
vault write -field=service_account_token kubernetes/creds/sample-app kubernetes_namespace=demo \
  | jwt decode - 


```