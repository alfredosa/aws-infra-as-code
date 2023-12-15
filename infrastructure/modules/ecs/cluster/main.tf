resource "aws_security_group" "ecs_agent" {
  name        = "cluster-sg-${var.environment}"
  description = "ECS Security Group"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 3000
    to_port   = 3000
    protocol  = "tcp"
    security_groups = var.load_balancer_security_group_ids
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