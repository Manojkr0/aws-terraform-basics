data "aws_vpc" "custom" {
  filter {
    name   = "tag:Name"
    values = ["vpc-basics"]   # <- Your VPC name
  }
}

resource "aws_security_group" "SG" {
  name        = "security-group"
  description = "Allow SSH and HTTP"
  vpc_id      = data.aws_vpc.custom.id
  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["49.204.201.195/32"] 
  }
  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  

  tags = {
    Name ="security-group"
  }
}
