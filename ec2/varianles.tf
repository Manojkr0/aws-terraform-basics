variable "ami_id" {
    type = string
    default = "ami-0f918f7e67a3323f0"  
}
variable "instance_type" {
    type = string  
    default = "t2.micro"  
}
variable "subnet_id" {
    type = string  
    default = "subnet-086d28cc86c8fb75a"  
}
variable "security_group" {
    type = string  
    default = "sg-01e77f5a887c80311"
  
}
