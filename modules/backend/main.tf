# 1. Our S3 bucket
resource "aws_s3_bucket" "terraform_state" {
  bucket = "our-terraform-state-bucket-333"

  #Protect against accidental deletion
  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name = "${var.project_name}-my-terraform-state-bucket"
  }
}

# 2. Enable Versioning
resource "aws_s3_bucket_versioning" "enable_V" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# 3. Enable Server-Side Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "enable_SSE" {
  bucket = aws_s3_bucket.terraform_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# 4. block all public access
resource "aws_s3_bucket_public_access_block" "block_PA" {
  bucket                  = aws_s3_bucket.terraform_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# 5. DynamoDB Table for State Locking
resource "aws_dynamodb_table" "Table_SL" {
  name         = "terraform_state_lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "${var.project_name}-dynamodb-state-locking"
  }
}

