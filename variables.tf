variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default = "ca-central-1"
}
 
variable "ec2_ami" {
  description = "The AMI to use for the EC2 instance"
  type        = string
  default = "ami-0e817e890550ad158"
}
 
variable "ec2_instance_type" {
  description = "The type of EC2 instance to launch"
  type        = string
  default = "t2.micro"
}
