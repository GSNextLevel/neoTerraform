resource "aws_lb" "nginx-nlb" {
  name               = var.nlb-name
  internal           = true
  load_balancer_type = "network"
  subnets            = data.aws_subnet_ids.private-sub[0].ids

  enable_deletion_protection = false

  tags = {
    Name = var.nlb-name
  }
}

resource "aws_lb_target_group" "nginx-nlb-tg" {
  count       = length(data.aws_vpcs.vpcs.ids)
  name        = "${var.nlb-name}-target"
  port        = 80
  protocol    = "TCP"
  target_type = "ip"
  vpc_id      = data.aws_vpc.target[count.index].id

  tags = {
    Name = "${var.nlb-name}-tg"
  }
}

resource "aws_lb_listener" "nginx-nlb-listener" {
  load_balancer_arn = aws_lb.nginx-nlb.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx-nlb-tg[0].arn
  }
}
