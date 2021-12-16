variable "region" {
  default = "ap-northeast-2"
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "cluster-name" {
  default = "eks-cluster-custom-nodegrp"
  type    = string
}

variable "instance_type" {
  default = ["c5.large"]
}

variable "image_id" {
  # https://docs.aws.amazon.com/ko_kr/eks/latest/userguide/eks-optimized-ami.html
  default = [""]
}

variable "node_group_name" {}
variable "key_name" {}

variable "asg_desired_size" {
  default = 1
}
variable "asg_max_size" {
  default = 1
}
variable "asg_min_size" {
  default = 1
}
