resource "aws_db_subnet_group" "private_subnet_group" {
  name       = "private_subnet_group"
  subnet_ids = [aws_subnet.private-subnet-1.id, aws_subnet.private-subnet-2.id]

  tags = {
    Name = "private_subnet_group"
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "Allow inbound traffic from ECS tasks"
  vpc_id      = aws_vpc.iac-vpc.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [aws_security_group.iac_agent.id]
  }
}

resource "aws_db_instance" "postgres" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "14"
  instance_class       = "db.t3.micro"
  db_name              = var.db_name
  username             = var.db_username
  password             = var.db_password
#   manage_master_user_password = true
  parameter_group_name = "default.postgres14"
  db_subnet_group_name = aws_db_subnet_group.private_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot = true
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  timeouts {
    create = "1h"
    delete = "1h"
    update = "1h"
  }
}