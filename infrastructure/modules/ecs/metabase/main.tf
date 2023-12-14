resource "aws_ecs_task_definition" "iac_metabase_task_definition" {
  family = "${var.org_name}-${var.environment}"
  cpu    = var.metabase_cpu
  memory = var.metabase_memory

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"

  container_definitions = jsonencode([
    {
      name  = "metabase-${var.org_name}-${var.environment}"
      image = "metabase/metabase:latest"
      cpu   = var.metabase_cpu
      memory = var.metabase_memory
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
          protocol      = "tcp"
        }
      ]
      environment = [
        {
          name  = "MB_DB_TYPE"
          value = "postgres"
        },
        {
          name  = "MB_DB_DBNAME"
          value = var.db_name
        },
        {
          name  = "MB_DB_PORT"
          value = "5432"
        },
        {
          name  = "MB_DB_USER"
          value = var.db_username
        },
        {
          name  = "MB_DB_PASS"
          value = var.db_password
        },
        {
          name  = "MB_DB_HOST"
          value = var.db_host
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = var.cloutwatch_group_name
          awslogs-region        = var.region
          awslogs-stream-prefix = "metabase-${var.org_name}-${var.environment}"
        }
      }
    }
  ])

  execution_role_arn = var.cluster_execution_role_arn
  task_role_arn = var.metabase_task_role_arn == null ? var.task_role_arn : var.metabase_task_role_arn
}

resource "aws_ecs_service" "metabase_service" {
  name          = "${var.org_name}-${var.environment}"
  cluster       = var.ecs_cluster_id
  desired_count = 1
  launch_type   = "FARGATE"

  load_balancer {
    target_group_arn = var.load_balancer_arn
    container_name   = "metabase-${var.org_name}-${var.environment}"
    container_port   = 3000
  }

  // Public IP required for pulling secrets and images
  // https://aws.amazon.com/premiumsupport/knowledge-center/ecs-unable-to-pull-secrets/
  network_configuration {
    security_groups  = [var.cluster_security_group_id]
    assign_public_ip = true
    subnets          = [var.public_subnet_ids[0], var.public_subnet_ids[1]]
  }
  task_definition = aws_ecs_task_definition.iac_metabase_task_definition.arn
}