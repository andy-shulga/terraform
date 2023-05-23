####################################
#
# Outputs to check status and importatn value from CLI
#
####################################

# Get current Region Name to get then AZ names
output "current_region" {
  value = data.aws_region.current.name
}

# GEt an loadbalancer DNS name
output "waeb_loadbalancer_url" {
  value = aws_elb.web.dns_name
}