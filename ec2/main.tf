# resource "aws_instance""ec2" {
#   ami           = var.ami_id
#   instance_type = var.instance_type
#   subnet_id = var.subnet_id
#   security_groups = [var.security_group]

#   tags = {
#     Name = "MyEC2Instance"
#   }
# }
# resource "aws_instance" "public_ec2" {
#   ami           = var.ami_id
#   instance_type = var.instance_type

#   subnet_id              = data.aws_subnet.public.id
#   vpc_security_group_ids = [data.terraform_remote_state.sg.outputs.sg_id]


#   associate_public_ip_address = true
#   key_name = "ec2key"   # <-- Your AWS key pair name


#   tags = {
#     Name = "Public-EC2"
#   }
# }
# resource "aws_instance" "private_ec2" {
#   ami           = var.ami_id
#   instance_type = var.instance_type

#   subnet_id              = data.aws_subnet.private.id
#   vpc_security_group_ids = [data.terraform_remote_state.sg.outputs.sg_id]

#     associate_public_ip_address = false
#   key_name = "ec2key"   # <-- Your AWS key pair name


#   tags = {
#     Name = "Private-EC2"
#   }
# }

# resource "aws_instance" "flask_ec2" {
#   ami           = var.ami_id
#   instance_type = var.instance_type
#   subnet_id     = data.aws_subnet.public.id
#   vpc_security_group_ids = [data.terraform_remote_state.sg.outputs.sg_id]

#   associate_public_ip_address = true
#   key_name = "ec2key"   # <-- Your AWS key pair name

#   tags = {
#     Name = "Flask-EC2"
#   }
# }                                     #2
resource "aws_instance" "flask_ec2" {
  count         = 2
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = data.aws_subnet.public.id
  vpc_security_group_ids = [data.aws_security_group.existing_ec2_sg.id]
  associate_public_ip_address = true
  key_name = "ec2key"

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
                  return "Hello py $(hostname)!"

              if __name__ == "__main__":
                  app.run(host='0.0.0.0', port=5000)
              EOPY

              nohup python3 /home/ec2-user/app.py > /home/ec2-user/app.log 2>&1 &
              EOF

  tags = {
    Name = "Flask-EC2-${count.index + 1}"
  }
}
