
####################################
#
# Create a iam roles
#
####################################

resource "aws_iam_role" "s3_ec2_role" {
  name = "AWSS3ReadAndRightRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}