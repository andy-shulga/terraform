####################################
#
# Outputs to check status and importatn value from CLI
#
####################################

output "public_ip" {
  value = aws_eip.my_eip.public_ip
}