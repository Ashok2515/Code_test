resource "aws_s3_bucket" "tfrmstate" {
  bucket        = var.remotestate_bucket
  force_destroy = true

  tags = {
    Name = "tf-remote-state"
  }
}
resource "aws_s3_bucket_acl" "_bucket_acl" {
  bucket = aws_s3_bucket.tfrmstate.id
  acl    = "private"
}
resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.tfrmstate.id
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_kms_key" "backend_encryption_key" {
  description             = "KMS Key for S3 Backend"
  deletion_window_in_days = 10
}
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.tfrmstate.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.backend_encryption_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}
resource "aws_s3_object" "rmstate_folder" {
  bucket = aws_s3_bucket.tfrmstate.id
  key = "terraform-aws/"
}

resource "aws_dynamodb_table" "terraform_statelock" {
  name = var.aws_dynamodb_table
  read_capacity = 5
  write_capacity = 5
  hash_key = "LockID"

  attribute {
      name = "LockID"
      type = "S"
  }
}
