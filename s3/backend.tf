terraform {
  backend "s3" {
    bucket         = "absapp-web-s3-backend"
    key            = "terraform-aws/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform_tfstatedb"
  }
}