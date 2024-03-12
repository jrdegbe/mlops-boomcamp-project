resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket_name
  #block_public_acls       = false
  #block_public_policy     = false
  #ignore_public_acls      = false
  #restrict_public_buckets = false
  force_destroy = true
}

resource "aws_s3_bucket_acl" "s3_bucket_act" {
  bucket = aws_s3_bucket.s3_bucket.id
  acl    = "private"
}

output "name" {
  value = aws_s3_bucket.s3_bucket.bucket
}
