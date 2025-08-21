terraform {
  required_version = "1.12.2"
  backend "s3" {
    bucket         = "terraformbackupmanoj6303"
    key            = "ec2/ec2.tfstate"
    region         = "us-west-2"
    use_lockfile= true
  }
}