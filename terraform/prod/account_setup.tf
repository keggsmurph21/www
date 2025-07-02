terraform {
  backend "s3" {
    bucket = "murp-us-tfstates"
    key    = "prod.tfstate"
    region = "us-east-1"

    assume_role = {
      role_arn = "arn:aws:iam::253722192782:role/murp-us-terraform"
    }
  }
}

provider "aws" {
  region = "us-east-1"

  assume_role {
    role_arn = "arn:aws:iam::253722192782:role/murp-us-prod"
  }

  default_tags {
    tags = {
      env = "prod"
    }
  }
}

data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}
