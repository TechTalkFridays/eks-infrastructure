terraform {
  required_version = ">= 0.12.20"
  backend "s3" {
    bucket = "production-morty-terraform-state"
    key    = "infrastructure.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}