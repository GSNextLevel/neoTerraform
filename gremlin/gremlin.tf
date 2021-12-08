provider "aws" {
  region = "us-west-2"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name   = "gremlin_vpc"

  cidr = "10.10.0.0/16"

  azs            = ["us-west-2a"]
  public_subnets = ["10.10.1.0/24"]

  tags = {
    Owner       = "SET OWNER"
    Environment = "chaos"
  }
}

module "security_group" {
  source      = "terraform-aws-modules/security-group/aws"
  name        = "ssh"
  description = "ssh from anywhere"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["ssh-tcp", "all-icmp"]
  egress_rules        = ["all-all"]
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*-x86_64-gp2", ]
  }
}

module "key_pair" {
  source = "terraform-aws-modules/key-pair/aws"

  key_name   = "SET YOUR KEY NAME"
  public_key = file("SET YOUR KEY LOCATION")
}

output "key_pair_key_name" {
  value = module.key_pair.key_pair_key_name
}

module "ec2" {
  source = "terraform-aws-modules/ec2-instance/aws"
  count  = 1

  name                        = "gremlin-instance"
  ami                         = data.aws_ami.amazon_linux.id
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [module.security_group.security_group_id]
  key_name                    = "gsn-jihun-admin"
  user_data = templatefile("userdata.tpl", {
    GREMLIN_PRIVATE_KEY = file("SET YOUR PRIVATE KEY LOCATION"),
    GREMLIN_CERTIFICATE = file("SET YOUR CERTIFICATE LOCATION"),
    GREMLIN_TEAM_ID     = "SET YOUR TEAM ID"
    }
  )


  tags = {
    Owner       = "SET OWNER"
    Environment = "chaos"
    DeployFrom  = "terraform"
  }
}
