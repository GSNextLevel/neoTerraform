resource "aws_ecs_cluster" "my-ecs" {
  name = var.cluster-name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "ecs-task" {
  family                   = var.ecs-task-name
  task_role_arn            = aws_iam_role.ecs-task.arn
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs-task.arn

  network_mode = "awsvpc"
  cpu          = 512
  memory       = 1024

  container_definitions = file("./service.json")

  runtime_platform {
    operating_system_family = "LINUX"
  }
}

resource "aws_ecs_service" "ecs-svc" {
  name                = var.ecs-service-name
  launch_type         = "FARGATE"
  cluster             = aws_ecs_cluster.my-ecs.id
  task_definition     = aws_ecs_task_definition.ecs-task.arn
  desired_count       = 1
  scheduling_strategy = "REPLICA"

  load_balancer {
    target_group_arn = data.aws_lb_target_group.nginx-nlb-tg.arn
    container_name   = "nginx"
    container_port   = 80
  }

  network_configuration {
    subnets          = data.aws_subnet_ids.private-sub[0].ids
    security_groups  = aws_security_group.allow_fargate[*].id
    assign_public_ip = true
  }
}
