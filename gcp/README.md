# GCP Terraform CICD Pipeline

## Github CICD
./github

## Gitlab CICD
.gitlab-ci.yaml

### Gitlab Credentials Key
Save the Service Account Key as Gitlab CICD Variable

### GCP Credentials Key for Github
```bash
vi gcp-credentials-key.json
press :

Add the following 
%s;\n; ;g
Press enter.

press : again

type wq!
```