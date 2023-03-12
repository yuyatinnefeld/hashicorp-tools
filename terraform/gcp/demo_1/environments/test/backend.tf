terraform {
  backend "gcs" {
    bucket      = "yuyatinnefeld-test-tf-state"
    prefix      = "state/resource"
    credentials = "../../creds/serviceaccount.json"
  }
}