provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

resource "aws_s3_bucket" "khoovi_bucket" {
  bucket = "tf-khoovi-bucket"
  acl    = "private"
}