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

resource "aws_security_group_rule" "allow_alb_to_ec2" {
  type                     = "ingress"
  from_port                = 8000
  to_port                  = 8000
  protocol                 = "tcp"
  source_security_group_id = data.aws_security_group.existing_alb_sg.id
  security_group_id        = data.aws_security_group.existing_ec2_sg.id
}

# ✅ Add SSH access (only from your IP)
resource "aws_security_group_rule" "allow_ssh_to_ec2" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["49.204.201.195/32"] # Replace with your IP
  security_group_id = data.aws_security_group.existing_ec2_sg.id
}

resource "aws_instance" "flask_ec2" {
  ami           = "ami-0f918f7e67a3323f0"
  instance_type = "t2.micro"
  subnet_id     = data.aws_subnet.public.id
  security_groups = [data.aws_security_group.existing_ec2_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras enable python3.8
              yum install -y python3.8 python3-pip git -y

              pip3 install flask

              cat <<EOPY > /home/ec2-user/app.py
              from flask import Flask
              app = Flask(__name__)

              @app.route("/")
              def hello():
                  return "Hellopy!"

              if __name__ == "__main__":
                  app.run(host='0.0.0.0', port=8000)
              EOPY

              # Kill old Flask if running
              pkill -f app.py || true

              # Run Flask app
              nohup python3 /home/ec2-user/app.py > /home/ec2-user/app.log 2>&1 &
              EOF

  tags = {
    Name = "Flask-EC2"
  }
}

resource "aws_lb" "AWS-ALB" {
  name               = "my-alb"
  load_balancer_type = "application"
  subnets            = [
    data.aws_subnet.public.id,
    data.aws_subnet.private.id
  ]
  security_groups = [data.aws_security_group.existing_alb_sg.id]

  enable_deletion_protection = false

  tags = {
    Name = "AWS-ALB"
  }
}
resource "aws_lb_target_group" "targets" {
  name_prefix = "lb-"   # generates something like lb-20230829a
  port        = 8000
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.custom.id

  health_check {
    path                = "/"
    port                = "8000"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }

  tags = {
    Name = "Target-Group"
  }

  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_lb_target_group_attachment" "flask_ec2_attach" {
  target_group_arn = aws_lb_target_group.targets.arn
  target_id        = aws_instance.flask_ec2.id
  port             = 8000
}
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.AWS-ALB.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.targets.arn
  }

  depends_on = [aws_lb_target_group.targets]
}

output "alb_dns_name" {
  value = aws_lb.AWS-ALB.dns_name
}

