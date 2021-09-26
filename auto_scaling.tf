resource "aws_launch_template" "my_teamplate" {
  name                   = "my_nginx_teamplate"
  image_id               = "ami-087c17d1fe0178315"
  instance_type          = "t2.micro"
  update_default_version = true
  user_data              = filebase64("nginx_teacher.sh")
  vpc_security_group_ids = [aws_security_group.rule_for_private_two.id]
  key_name               = aws_key_pair.key_pair.key_name
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "fromALB"
      owner       = "ME"
      project     = "ALB"
      environment = "BASTION_ENV"
    }
  }
  tag_specifications {
    resource_type = "volume"
    tags = {
      owner       = "ME"
      project     = "ALB"
      environment = "BASTION_ENV"
    }
  }
  iam_instance_profile {
    name = aws_iam_role.ec2_s3.name
  }
}
resource "aws_autoscaling_group" "my_asg" {
  name                = "my_asg"
  target_group_arns   = [aws_alb_target_group.instance-target-group.arn]
  desired_capacity    = 2
  max_size            = 6
  min_size            = 2
  vpc_zone_identifier = [aws_subnet.subnet_two_private.id, aws_subnet.subnet_2_two_private.id]
  default_cooldown    = 20
  launch_template {
    id      = aws_launch_template.my_teamplate.id
    version = "$Latest"
  }
  depends_on = [aws_launch_template.my_teamplate, aws_vpc_endpoint.s3_for_distrib]
}

resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = aws_autoscaling_group.my_asg.id
  alb_target_group_arn   = aws_alb_target_group.instance-target-group.arn
}
resource "aws_autoscaling_policy" "my_policy_cpu" {
  name                      = "my_policy_cpu"
  autoscaling_group_name    = aws_autoscaling_group.my_asg.name
  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = 10
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 0.00001
  }
}
