variable whitelist {
  type    = list(string)
  default = ["0.0.0.0/0"]
}
variable web_image_id {
  type    = string
  default = "ami-019c091d13a1fa156"
}
variable web_instance_type {
  type    = string
  default = "t2.micro"
}
variable web_desired_capacity {
  type    = number
  default = 1
}
variable web_max_size {
  type    = number
  default = 1
}
variable web_min_size {
  type    = number
  default = 1
}

provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

resource "aws_s3_bucket" "prod_tf_khoovi_course" {
  bucket = "tf-course-khoovi-bucket"
  acl    = "private"
}

resource "aws_default_vpc" "default" {}

resource "aws_default_subnet" "default_az1" {
  availability_zone = "us-west-2a"

  tags = {
    "Terraform" : "true"
  }
}

resource "aws_default_subnet" "default_az2" {
  availability_zone = "us-west-2b"

  tags = {
    "Terraform" : "true"
  }
}

resource "aws_security_group" "prod_web" {
  name        = "prod_web"
  description = "Allow standard http and https port inbound and everything outbound"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.whitelist
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.whitelist
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.whitelist
  }

  tags = {
    "Terraform" : "true"
  }
}

module "web_app" {
  source               = "./modules/webapp"
  web_image_id         = var.web_image_id
  web_instance_type    = var.web_instance_type
  web_desired_capacity = var.web_desired_capacity
  web_max_size         = var.web_max_size
  min_size             = var.min_size
  subnets              = [aws_default_subnet_az1.id, aws_default_subnet_az2.id]
  security_groups      = [aws_security_group.prod_web.id]
  web_app              = "prod"
}
