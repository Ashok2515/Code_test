terraform {
    required_providers {
      aws = {
        source  = "hashicorp/aws"
        version = ">=4.45.0"
      }
    }
    required_version = ">= 1.1"
}
provider "aws" {
  region = var.aws_region
  shared_credentials_files = ["c:/Users/Administrator/.aws/credentials"]
  profile = "awsuser"
}