resource "aws_security_group" "lb_sg" {
  name        = "lb-sg-${var.environment}"
  description = "Allow inbound traffic"
  vpc_id      = var.vpc_id


// accept connections from the internet on port 3000, 80, and 443 (Metabase, PGAdmin, and HTTPS)
// accept all outgoing connections
  ingress = [
    {
      from_port   = 3000
      to_port     = 3000
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Required Port for Metabase"
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Required port for PGAdmin"
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Required port for HTTPS"
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false
    }
  ]

  egress = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all outgoing traffic"
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false
    }
  ]
}

resource "aws_lb" "load_balancer" {
  name               = "lb-${var.environment}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [var.public_subnet_1_id, var.public_subnet_2_id]
}

resource "aws_lb_listener" "metabase" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = "3000"
  protocol          = "HTTP"
  depends_on = [ aws_lb.metabase ]

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.metabase.arn
  }
}

resource "aws_lb_target_group" "metabase" {
  name     = "metabase-tg-${var.environment}"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  target_type = "ip"

  health_check {
    enabled             = true
    interval            = 30
    path                = "/api/health"
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}
