resource "aws_security_group" "rds_sg" {
  name        = "${var.dedicated_service}-db-${var.environment}"
  description = "Allow inbound traffic from ECS tasks"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.ecs_cluster_security_group_id] // var ecs cluster incoming traffic
  }
}

resource "aws_db_instance" "postgres" {
  allocated_storage = 20
  storage_type      = "gp2"
  engine            = "postgres"
  engine_version    = "14"
  instance_class    = var.db_instance_class
  db_name           = var.db_name
  username          = var.db_username
  password          = var.db_password
  #   manage_master_user_password = true
  parameter_group_name            = "default.postgres14"
  db_subnet_group_name            = var.private_subnet_group_name // Var
  vpc_security_group_ids          = [aws_security_group.rds_sg.id] 
  skip_final_snapshot             = true
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  timeouts {
    create = "1h"
    delete = "1h"
    update = "1h"
  }
}