variable "region" {
  default = "ap-northeast-2"
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "cluster-name" {
  default = "terraform-eks-cluster"
  type    = string
}

variable "instance_type" {
  default = ["c5.large"]
}

variable "image_id" {
  default = ["ami-0ba9feae3dafa4606"]
}
