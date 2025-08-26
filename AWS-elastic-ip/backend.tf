terraform {
  required_version = "1.12.2"
  backend "s3" {
    bucket         = "terraformbackupmanoj6303"
    key            = "AWS-elastic-ip/AWS-elastic-ip.tfstate"
    region         = "us-west-2"
    use_lockfile= true
  }
}