# resource "aws_lb" "AWS-ALB" {
#   name               = "my-alb"
#   load_balancer_type = "application"
#    subnets            = [
#     data.aws_subnet.public.id,         
#     data.aws_subnet.private.id         
#   ]  
#   security_groups    = [data.aws_security_group.existing_alb_sg.id]

#   enable_deletion_protection = false

#   tags = {
#     Name = "AWS-ALB"
#   }
# }
# resource "aws_lb_target_group" "targets" {
#   name     = "lb-tg"
#   port     = 80
#   protocol = "HTTP"
#   vpc_id   = data.aws_vpc.custom.id

#   health_check {
#     path                = "/"
#     interval            = 30
#     timeout             = 5
#     healthy_threshold   = 2
#     unhealthy_threshold = 2
#     matcher             = "200"
#   }

#   tags = {
#     Name = "Target-Group"
#   }
# }
# resource "aws_lb_target_group_attachment" "tg_attach_public" {
#   target_group_arn = aws_lb_target_group.targets.arn
#   target_id        = data.aws_instance.public_ec2.id
#   port             = 80
# }

# resource "aws_lb_target_group_attachment" "tg_attach_private" {
#   target_group_arn = aws_lb_target_group.targets.arn
#   target_id        = data.aws_instance.private_ec2.id
#   port             = 80
# }
# resource "aws_lb_listener" "http_listener" {
#   load_balancer_arn = aws_lb.AWS-ALB.arn
#   port              = 80
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.targets.arn
#   }
# }

resource "aws_lb" "app_alb" {
  name               = "flask-alb"
  load_balancer_type = "application"
  subnets            = [data.aws_subnet.public.id]
  security_groups    = [data.aws_security_group.existing_alb_sg.id]

  enable_deletion_protection = false

  tags = {
    Name = "Flask-ALB"
  }
}

resource "aws_lb_target_group" "flask_targets" {
  name_prefix = "flask"
  port        = 5000
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.custom.id

  health_check {
    path                = "/"
    port                = "5000"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

resource "aws_lb_target_group_attachment" "flask_attach_public" {
  target_group_arn = aws_lb_target_group.flask_targets.arn
  target_id        = data.aws_instance.public_ec2.id
  port             = 5000
}

resource "aws_lb_target_group_attachment" "flask_attach_private" {
  target_group_arn = aws_lb_target_group.flask_targets.arn
  target_id        = data.aws_instance.private_ec2.id
  port             = 5000
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.flask_targets.arn
  }
}

output "alb_dns_name" {
  value = aws_lb.app_alb.dns_name
}
