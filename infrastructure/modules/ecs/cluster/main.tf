resource "aws_iam_role" "ecs_agent_execution_role" {
  name = "execution-role-${var.environment}"

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
    name = "ssm-allow-read-ecs-api-key-${var.environment}"
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

resource "aws_iam_role" "ecs_metabase_task_role" {
  name  = "task-role-${var.environment}"
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

resource "aws_security_group" "ecs_agent" {
  name        = "cluster-sg-${var.environment}"
  description = "ECS Security Group"
  vpc_id      = aws_vpc.ecs-vpc.id

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

resource "aws_ecs_cluster" "ecs_agent_cluster" {
  name = "${var.org_name}-${var.environment}"
}

resource "aws_ecs_cluster_capacity_providers" "ecs_agent_cluster_capacity_providers" {
  cluster_name       = aws_ecs_cluster.ecs_agent_cluster.name
  capacity_providers = ["FARGATE"]
}