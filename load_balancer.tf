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

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.metabase.arn
  }
}

resource "aws_lb_target_group" "metabase" {
  name     = "metabase-tg"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_target_group_attachment" "metabase" {
  target_group_arn = aws_lb_target_group.metabase.arn
  target_id        = aws_ecs_service.metabase.id
  port             = 3000
}