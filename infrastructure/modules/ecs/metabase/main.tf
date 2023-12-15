resource "aws_iam_role" "ecs_agent_execution_role" {
  name = "execution-role-metabase-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })

  inline_policy {
    name = "ssm-allow-read-ecs-api-key-metabase-${var.environment}"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
        "ssm:GetParameter*",
        "ssm:GetParameters",
        "ssm:GetParameter",
        "ssm:GetParametersByPath",
        "secretsmanager:GetSecretValue"
      ],
          Effect = "Allow"
          Resource = ["arn:aws:ssm:eu-west-2:197578819129:parameter/*"]
        },
        {
            Effect: "Allow",
            Action: [
                "kms:Decrypt"
            ],
            Resource: "arn:aws:kms:eu-west-2:197578819129:key/0a7e7860-111f-4226-9f37-7fc0de7faab2"
        }
      ]
    })
  }
  // AmazonECSTaskExecutionRolePolicy is an AWS managed role for creating ECS tasks and services
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"]
}

resource "aws_iam_role" "ecs_task_role" {
  name  = "task-role-metabase-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })

  inline_policy {
    name = "allow-ecs-task-${var.environment}"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "ec2:DescribeSubnets",
            "ec2:DescribeVpcs",
            "ecr:BatchCheckLayerAvailability",
            "ecr:BatchGetImage",
            "ecr:GetAuthorizationToken",
            "ecr:GetDownloadUrlForLayer",
            "ecs:DeregisterTaskDefinition",
            "ecs:DescribeTasks",
            "ecs:RegisterTaskDefinition",
            "ecs:RunTask",
            "iam:PassRole",
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:GetLogEvents",
            "logs:PutLogEvents"
          ]
          Effect   = "Allow"
          Resource = "*"
        }
      ]
    })
  }
}

resource "aws_ecs_task_definition" "iac_metabase_task_definition" {
  family = "metabase-${var.org_name}-${var.environment}"
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
          awslogs-group         = var.cloudwatch_group_name
          awslogs-region        = var.region
          awslogs-stream-prefix = "metabase-${var.org_name}-${var.environment}"
        }
      }
    }
  ])

  execution_role_arn = aws_iam_role.ecs_agent_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_role.arn
}

resource "aws_ecs_service" "metabase_service" {
  name          = "metabase-${var.org_name}-${var.environment}"
  cluster       = var.ecs_cluster_id
  desired_count = 1
  launch_type   = "FARGATE"
  
  load_balancer {
    target_group_arn = var.load_balancer_target_group_arn
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