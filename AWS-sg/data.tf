data "aws_vpc" "custom" {
  filter {
    name   = "tag:Name"
    values = ["vpc-basics"]   # <- Your VPC name
  }
}