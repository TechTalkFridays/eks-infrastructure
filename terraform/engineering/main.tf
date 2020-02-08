terraform {
  required_version = ">= 0.12.20"
  backend "s3" {
    bucket = "techtalkfridays-terraform-state"
    key    = "engineering.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}