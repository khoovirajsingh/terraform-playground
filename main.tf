provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

resource "aws_s3_bucket" "prod_tf_khoovi_course" {
  bucket = "tf-course-khoovi-bucket"
  acl    = "private"
}

resource "aws_default_vpc" "default" {}
