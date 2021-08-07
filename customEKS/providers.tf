terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}
