data "aws_vpc" "custom" {
  filter {
    name   = "tag:Name"
    values = ["vpc-basics"]  
  }
}
data "aws_subnet" "public" {
  filter {
    name   = "tag:Name"
    values = ["public-subnet"]   
  }
  vpc_id = data.aws_vpc.custom.id
}
data "aws_subnet" "private" {
  filter {
    name   = "tag:Name"
    values = ["private-subnet"]  
  }
  vpc_id = data.aws_vpc.custom.id
}
data "aws_security_group" "existing_alb_sg" {
  id = "sg-038a76efce48b252d"   
}


data "aws_instance" "public_ec2" {
  instance_id = "i-038c231c6e1338bec"   
}

data "aws_instance" "private_ec2" {
  instance_id = "i-00f7e96c621cee4cc"   
}
data "aws_security_group" "existing_ec2_sg" {
  id = "sg-01e77f5a887c80311"   # your EC2 security group
}
