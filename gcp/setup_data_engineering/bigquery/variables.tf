# PROJECT CONFIG

variable "cred" {
    default = "./conf/service_account.json"
}

variable "project_id" {
    default = "yyterraform"
}

variable "region" {
    default = "europe-west3"
}

variable "zone" {
    default = "europe-west3-b"
}


# BIGQUERY CONFIG

variable "ds_prod_name" {
    default = "ds_eu_prod"
}

variable "ds_dev_name" {
    default = "ds_eu_dev"
}


