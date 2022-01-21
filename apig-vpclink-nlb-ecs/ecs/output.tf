output "fargate-sg" {
  value = aws_security_group.allow_fargate[*].id
}

output "ecs-task-role" {
  value = aws_iam_role.ecs-task.arn
}

output "lb-arn" {
  value = data.aws_lb.nginx-nlb.arn
}

output "lb-target-arn" {
  value = data.aws_lb_target_group.nginx-nlb-tg.arn
}
