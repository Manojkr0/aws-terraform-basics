terraform {
  required_version = "1.12.2"
  backend "s3" {
    bucket         = "terraformbackupmanoj6303"
    key            = "AWS-loadbalancers/AWS-loadbalancers.tfstate"
    region         = "us-west-2"
    use_lockfile= true
  }
}