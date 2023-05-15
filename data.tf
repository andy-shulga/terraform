####################################
#
# File to get data from AWS
#
####################################

data "aws_ami" "ami_name" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-*"]
  }
}

data "aws_region" "current" {}

data "aws_availability_zones" "available" {}