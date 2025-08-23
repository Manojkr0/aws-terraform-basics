terraform {
  required_version = "1.12.2"
  backend "s3" {
    bucket         = "terraformbackupmanoj6303"
    key            = "AWS-S3/AWS-S3.tfstate"
    region         = "us-west-2"
    use_lockfile= true
  }
}