variable "region" {
  default = "us-west-2"
}

variable "apigateway-name" {
  default = "APIG-NLB-ECS-TEST"
}

variable "nlb-name" {
  default = "nginx-nlb"
}

variable "vpc-name" {
  default = "my-vpc"
}

variable "vpclink_name" {
  default = "nginx-vpclink"
}

variable "my_domain" {}

variable "custom_domain" {}
