terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  region = var.region
}

# Get VPC ID
data "aws_vpcs" "vpcs" {
  tags = {
    Name = var.vpc-name
  }
}

data "aws_vpc" "target" {
  count = length(data.aws_vpcs.vpcs.ids)
  id    = tolist(data.aws_vpcs.vpcs.ids)[count.index]
}

# Get Subnet IDs
data "aws_subnet_ids" "private-sub" {
  count = length(data.aws_vpcs.vpcs.ids)
  vpc_id = data.aws_vpc.target[count.index].id

  tags = {
    Name = "${var.vpc-name}-private-*"
  }
}

# Get ELB
data "aws_lb" "nginx-nlb" {
  tags = {
    Name = var.nlb-name
  }
}

data "aws_lb_target_group" "nginx-nlb-tg" {
  tags = {
    Name = "${var.nlb-name}-tg"
  }
}