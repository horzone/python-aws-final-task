resource "aws_alb" "MyALB" {
  name               = "MyALB"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.subnet_two_private.id, aws_subnet.subnet_2_two_private.id, aws_subnet.subnet_two_public.id]
  ip_address_type    = "ipv4"
  security_groups    = [aws_security_group.allow_any-my_vpc_two.id]
}

resource "aws_alb_target_group" "instance-target-group" {
  name        = "AlbTargetGroup"
  port        = 8888
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc_two.id
  target_type = "instance"

}


resource "aws_alb_listener" "nginx" {
  load_balancer_arn = aws_alb.MyALB.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.instance-target-group.arn
  }

}
