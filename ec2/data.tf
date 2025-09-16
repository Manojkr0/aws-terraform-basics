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
data "terraform_remote_state" "sg" {
  backend = "s3"
  config = {
    bucket = "terraformbackupmanoj6303"
    key    = "security-group/sg.tfstate"
    region = "us-west-2"
  }
}

data "aws_security_group" "existing_alb_sg" {
  filter {
    name   = "tag:Name"
    values = ["security-group"]
  }
}

data "aws_security_group" "existing_ec2_sg" {
  filter {
    name   = "tag:Name"
    values = ["new-sg"]
  }
}
