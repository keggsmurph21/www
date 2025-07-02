terraform {
  backend "s3" {
    bucket = "murp-us-tfstates"
    key    = "iam.tfstate"
    region = "us-east-1"

    assume_role = {
      role_arn = "arn:aws:iam::253722192782:role/murp-us-terraform"
    }
  }
}

provider "aws" {
  region = "us-east-1"

  assume_role {
    role_arn = "arn:aws:iam::253722192782:role/murp-us-superuser"
  }
}

data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}
