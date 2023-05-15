####################################
#
# Define the Variables
#
####################################

variable "region" {
  default = "us-east-1"
}

variable "ec2_count" {
  type = number
  default = 2
}