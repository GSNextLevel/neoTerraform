output "lb_target_arn" {
  value = aws_lb_target_group.nginx-nlb-tg[*].arn
}

output "domain_arn" {
  value = data.aws_acm_certificate.amazon_issued.arn
}