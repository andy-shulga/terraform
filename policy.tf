
####################################
#
# Create a iam policys
#
####################################

resource "aws_iam_role_policy" "s3_ec2_policy" {
  name = "AWSS3ReadAndRightPolicy"
  role = aws_iam_role.s3_ec2_role.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Resource": "arn:aws:s3:::optimist991-s3-bucket-terraform-test/*"  
    }
  ]
}
EOF
}