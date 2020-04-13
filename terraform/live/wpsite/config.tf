terraform {
  required_version = ">= 0.12, < 0.13"
  backend "s3" {
    bucket         = "wpsite-development-tfstate"
    key            = "development/eks/terraform.tfstate"
    dynamodb_table = "wpsite-development-tfstate-locks"
    region         = "eu-west-1"
    encrypt        = true
  }
}

provider "aws" {
  region  = "eu-west-1"
  version = "~> 2.0"
}