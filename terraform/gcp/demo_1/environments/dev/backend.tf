terraform {
  backend "gcs" {
    bucket      = "yuyatinnefeld-dev-tf-state"
    prefix      = "state/resource"
    credentials = "../../creds/serviceaccount.json"
  }
}