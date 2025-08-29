resource "aws_eip" "eip" {
    instance = data.aws_instance.public_ec2.id
    tags = {
      Name = "my-eip"
    }
}
