####################################
#
# Outputs to check status and importatn value from CLI
#
####################################

/*
# Get Public IP to the EC2 (not autoscaling)
output "public_ip" {
  value = aws_eip.my_eip.public_ip
}
*/

# Get current Region Name to get then AZ names
output "current_region" {
  value = data.aws_region.current.name
}

# GEt an loadbalancer DNS name
output "waeb_loadbalancer_url" {
  value = aws_elb.web.dns_name
}