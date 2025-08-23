resource "aws_s3_bucket" "bucket" {
  bucket         = var.bucket_name
  acl         = "private"

  tags = {
    Name = "manoj"
  }
}
    

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.bucket.id 

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_object" "file" {
  bucket = aws_s3_bucket.bucket.id
  key = "notes"
  source = "readme"
  acl = "private"
  etag = filemd5("readme")
}
