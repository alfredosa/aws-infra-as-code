resource "aws_iam_role" "iac_agent_execution_role" {
  name = "execution-role-${var.name}"

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
    name = "ssm-allow-read-iac-api-key-${var.name}"
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

resource "aws_iam_role" "iac_metabase_task_role" {
  name  = "task-role-${var.name}"
  count = var.metabase_task_role_arn == null ? 1 : 0

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
    name = "allow-ecs-task-${var.name}"
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

resource "aws_cloudwatch_log_group" "iac_agent_log_group" {
  name              = "log-group-${var.name}"
  retention_in_days = var.agent_log_retention_in_days
}

resource "aws_security_group" "iac_agent" {
  name        = "cluster-sg-${var.name}"
  description = "ECS iac Agent"
  vpc_id      = aws_vpc.iac-vpc.id

  ingress {
    from_port = 3000
    to_port   = 3000
    protocol  = "tcp"
    security_groups = [aws_security_group.lb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    ipv6_cidr_blocks = [ "::/0" ]
  }
}

resource "aws_ecs_cluster" "iac_agent_cluster" {
  name = "${var.name}"
}

resource "aws_ecs_cluster_capacity_providers" "iac_agent_cluster_capacity_providers" {
  cluster_name       = aws_ecs_cluster.iac_agent_cluster.name
  capacity_providers = ["FARGATE"]
}

resource "aws_ecs_task_definition" "iac_metabase_task_definition" {
  family = "${var.name}"
  cpu    = var.metabase_cpu
  memory = var.metabase_memory

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"

  container_definitions = jsonencode([
    {
      name  = "metabase-${var.name}"
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
          value = aws_db_instance.postgres.address
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.iac_agent_log_group.name
          awslogs-region        = var.region
          awslogs-stream-prefix = "metabase-${var.name}"
        }
      }
    }
  ])

  execution_role_arn = aws_iam_role.iac_agent_execution_role.arn
  task_role_arn = var.metabase_task_role_arn == null ? aws_iam_role.iac_metabase_task_role[0].arn : var.metabase_task_role_arn
}

resource "aws_ecs_service" "metabase_service" {
  name          = "${var.name}"
  cluster       = aws_ecs_cluster.iac_agent_cluster.id
  desired_count = 1
  launch_type   = "FARGATE"

  load_balancer {
    target_group_arn = aws_lb_target_group.metabase.arn
    container_name   = "metabase-${var.name}"
    container_port   = 3000
  }

  // Public IP required for pulling secrets and images
  // https://aws.amazon.com/premiumsupport/knowledge-center/ecs-unable-to-pull-secrets/
  network_configuration {
    security_groups  = [aws_security_group.iac_agent.id]
    assign_public_ip = true
    subnets          = [aws_subnet.public-subnet-1.id,aws_subnet.public-subnet-2.id]
  }
  task_definition = aws_ecs_task_definition.iac_metabase_task_definition.arn
}
