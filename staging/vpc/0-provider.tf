terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.2"
    }


  }
  backend "local" {
    path = "staging/vpc/terraform.tfstate"
  }
}

provider "aws" {
  region = "us-east-1"
}