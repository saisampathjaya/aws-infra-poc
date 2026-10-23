terraform {
  backend "s3" {
    bucket         = "terraform-state-poc-123"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}