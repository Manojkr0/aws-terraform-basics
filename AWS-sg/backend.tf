terraform {
  required_version = "1.12.2"

  backend "s3" {
    bucket         = "terraformbackupmanoj6303"  
    key            = "security-group/sg.tfstate"  
    region         = "ap-south-1"                 
    encrypt        = true
  }
}