resource "aws_s3_bucket" "bucket" {
  bucket = "bucketfortestquantori"
  acl    = "private"
  versioning {
    enabled = true
  }
  lifecycle_rule {
    enabled = true

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    expiration {
      days                         = 90
      expired_object_delete_marker = true

    }
    tags = {
      Name = "My bucket"
    }
  }
}
resource "aws_s3_bucket_object" "file" {
  bucket = aws_s3_bucket.bucket.bucket
  key    = "file.name.txt"
  source = "./for_s3.txt"
  etag   = filemd5("./for_s3.txt")
}
