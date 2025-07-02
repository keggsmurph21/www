terraform {
  backend "s3" {
    bucket = "murp-us-tfstates"
    key    = "dev.tfstate"
    region = "us-east-1"

    assume_role = {
      role_arn = "arn:aws:iam::253722192782:role/murp-us-terraform"
    }
  }
}

provider "aws" {
  region = "us-east-1"

  assume_role {
    role_arn = "arn:aws:iam::253722192782:role/murp-us-dev"
  }

  default_tags {
    tags = {
      env = "dev"
    }
  }
}

data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}
