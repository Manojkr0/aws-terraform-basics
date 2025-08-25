# resource "aws_instance""ec2" {
#   ami           = var.ami_id
#   instance_type = var.instance_type
#   subnet_id = var.subnet_id
#   security_groups = [var.security_group]

#   tags = {
#     Name = "MyEC2Instance"
#   }
# }
data "aws_vpc" "custom" {
  id = "vpc-07c2949af07af0978"
}
data "aws_subnet" "public" {
  id = "subnet-086d28cc86c8fb75a"
  
}
data "aws_subnet" "private" {
  id = "subnet-0462351fe9a751ed9"
}
data "aws_security_group" "existing" {
  filter {
    name   = "group-name"
    values = ["default"]
  }
  vpc_id = data.aws_vpc.custom.id
}

resource "aws_instance" "public_ec2" {
  ami           = var.ami_id
  instance_type = var.instance_type

  subnet_id              = data.aws_subnet.public.id
  vpc_security_group_ids = [data.aws_security_group.existing.id]

  associate_public_ip_address = true

  tags = {
    Name = "Public-EC2"
  }
}

resource "aws_instance" "private_ec2" {
  ami           = var.ami_id
  instance_type = var.instance_type

  subnet_id              = data.aws_subnet.private.id
  vpc_security_group_ids = [data.aws_security_group.existing.id]

  associate_public_ip_address = false

  tags = {
    Name = "Private-EC2"
  }
}
