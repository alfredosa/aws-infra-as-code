resource "aws_security_group" "lb_sg" {
  name        = "lb_sg"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.iac-vpc.id

  ingress = [
    {
      from_port   = 3000
      to_port     = 3000
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = ""
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
      description = ""
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
      description = ""
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
      description = ""
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false
    }
  ]
}

resource "aws_lb" "metabase" {
  name               = "metabase-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [aws_subnet.public-subnet-1.id, aws_subnet.public-subnet-2.id]
}

resource "aws_lb_listener" "metabase" {
  load_balancer_arn = aws_lb.metabase.arn
  port              = "3000"
  protocol          = "HTTP"
  depends_on = [ aws_lb.metabase ]

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.metabase.arn
  }
}

resource "aws_lb_target_group" "metabase" {
  name     = "metabase-tg"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = aws_vpc.iac-vpc.id

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
