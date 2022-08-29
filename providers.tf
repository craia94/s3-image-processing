terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.28"
    }
  }
  backend "local" {
    path = "s3-image-processing.tfstate"
  }
  # backend "s3" {
  #   key = "s3-image-processing.tfstate"
  # }
}

provider "aws" {
  region = var.region
}

# terraform {
#   # backend "s3" {
#   #   key = "s3-image-processing.tfstate"
#   # }
#   backend "local" {
#     path = "s3-image-processing.tfstate"
#   }
# }
