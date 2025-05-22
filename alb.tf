resource "aws_lb_target_group" "webapp_tg" {
  name        = "webapp-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.webapp-vpc.id
  target_type = "instance"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group_attachment" "web1" {
  target_group_arn = aws_lb_target_group.webapp_tg.arn
  target_id        = aws_instance.webapp-1.id
  port             = 80
}
resource "aws_lb_target_group_attachment" "web2" {
  target_group_arn = aws_lb_target_group.webapp_tg.arn
  target_id        = aws_instance.webapp-2.id
  port             = 80
}

resource "aws_lb" "webapp_alb" {
  name               = "webapp-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.Allow_port_22_and_80.id]
  subnets = [
    aws_subnet.webapp-subnet_1.id,
    aws_subnet.webapp-subnet_2.id
  ]
  tags = {
    Name = "webapp-alb"
  }
}
resource "aws_lb_listener" "webapp_listener" {
  load_balancer_arn = aws_lb.webapp_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webapp_tg.arn
  }
}
