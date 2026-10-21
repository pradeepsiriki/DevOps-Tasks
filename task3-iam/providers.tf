terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "pradeep-tfstate-379959319021"
    key            = "task3-iam/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}

# Account A
provider "aws" {
  alias  = "account_a"
  region = var.region
}

# Account B
# For testing, both providers use the same account.
# With a real second account, add this inside the block:
#   assume_role {
#     role_arn = "arn:aws:iam::<account_b_id>:role/OrganizationAccountAccessRole"
#   }
provider "aws" {
  alias  = "account_b"
  region = var.region
}