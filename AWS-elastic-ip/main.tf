data "aws_instance" "public_ec2" {
  instance_id = "i-0830a711c3a14734f"   # Public-EC2
}
resource "aws_eip" "eip" {
    instance = data.aws_instance.public_ec2.id
}
