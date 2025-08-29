# resource "aws_instance""ec2" {
#   ami           = var.ami_id
#   instance_type = var.instance_type
#   subnet_id = var.subnet_id
#   security_groups = [var.security_group]

#   tags = {
#     Name = "MyEC2Instance"
#   }
# }
resource "aws_instance" "public_ec2" {
  ami           = var.ami_id
  instance_type = var.instance_type

  subnet_id              = data.aws_subnet.public.id
  vpc_security_group_ids = [data.terraform_remote_state.sg.outputs.sg_id]


  associate_public_ip_address = true

  tags = {
    Name = "Public-EC2"
  }
}
resource "aws_instance" "private_ec2" {
  ami           = var.ami_id
  instance_type = var.instance_type

  subnet_id              = data.aws_subnet.private.id
  vpc_security_group_ids = [data.terraform_remote_state.sg.outputs.sg_id]

  associate_public_ip_address = false

  tags = {
    Name = "Private-EC2"
  }
}

