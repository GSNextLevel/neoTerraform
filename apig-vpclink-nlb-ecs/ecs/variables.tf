variable "region" {
  default = "us-west-2"
}

variable "vpc-name" {
  default = "my-vpc"
}

variable "cluster-name" {
  default = "nginx-cluster"
  type    = string
}

variable "ecs-task-name" {
  default = "nginx-task"
}

variable "ecs-service-name" {
  default = "nginx-svc"
}

variable "nlb-name" {
  default = "nginx-nlb"
}
