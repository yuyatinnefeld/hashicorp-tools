provider "aws" {
  access_key = "xxxx"
  secret_key = "yyyy"
  region     = "zzzz"
}

resource "aws_s3_bucket" "prod_tf"{
  bucket = "tf-yt-learning-20210000"
  acl	 = "private"
}