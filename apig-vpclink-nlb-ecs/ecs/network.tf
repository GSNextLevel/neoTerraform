# Create SG for Fargate
resource "aws_security_group" "allow_fargate" {
  name        = "allow_fargate"
  description = "Allow Fargate inbound traffic"
  count = length(data.aws_vpcs.vpcs.ids)
  vpc_id      = data.aws_vpc.target[count.index].id

  ingress {
    description = "Fargate Inbound"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_fargate"
  }
}
