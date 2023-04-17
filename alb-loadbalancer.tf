#AWS LoadBalancer Target Group
resource "aws_lb_target_group" "Paymentology-tg" {
  name     = "Paymentology-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.Paymentology.id
  health_check {
    enabled             = true
    healthy_threshold   = 3
    interval            = 10
    matcher             = 200
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 3
    unhealthy_threshold = 2
  }
}
#LoadBalancer Target Group Attachment
resource "aws_lb_target_group_attachment" "Paymentology-tg-attached" {
  count            = length(aws_instance.Paymentology-Web-Server)
  target_group_arn = aws_lb_target_group.Paymentology-tg.arn
  target_id        = element(aws_instance.Paymentology-Web-Server.*.id, count.index)
  port             = 80
}
#LoadBalancer Listener
resource "aws_lb_listener" "Paymentology-lb-listener" {
  load_balancer_arn = aws_lb.Paymentology.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.Paymentology-tg.arn
  }
}
#LoadBalancer
resource "aws_lb" "Paymentology" {
  name               = "Paymentology"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.Paymentology-http-sg.id]
  subnets            = [for subnet in aws_subnet.private : subnet.id]

  enable_deletion_protection = false

  tags = {
    Environment = "Paymentology"
  }
}