terraform {
  required_version = ">= 1.6.0"

  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }

    random = {
      source = "hashicorp/random"
    }

    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.7"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}
