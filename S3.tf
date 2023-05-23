
####################################
#
# Create a S3 an setup role and permissions
#
####################################

resource "aws_s3_bucket" "my_s3_test" {
  bucket        = "optimist991-s3-bucket-terraform-test"
  force_destroy = true

  tags = {
    Name       = "My test bucket"
    Enviroment = "Test"
  }
}

resource "aws_s3_bucket_ownership_controls" "s3_owner_controle" {
  bucket = aws_s3_bucket.my_s3_test.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "S3_public_block" {
  bucket = aws_s3_bucket.my_s3_test.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "example" {
  depends_on = [
    aws_s3_bucket_ownership_controls.s3_owner_controle,
    aws_s3_bucket_public_access_block.S3_public_block,
  ]

  bucket = aws_s3_bucket.my_s3_test.id
  acl    = "public-read"
}