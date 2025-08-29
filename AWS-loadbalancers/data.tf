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
  instance_id = "i-0830a711c3a14734f"   
}

data "aws_instance" "private_ec2" {
  instance_id = "i-0837821c1b1707595"   
}