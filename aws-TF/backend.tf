provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = var.s3_bucket_name

  tags = {
    Name        = var.s3_bucket_name
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_versioning" "my_bucket_versioning" {
  bucket = aws_s3_bucket.my_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "my_bucket_lifecycle" {
  bucket = aws_s3_bucket.my_bucket.id

  rule {
    id     = "delete-old-versions"
    status = "Enabled"

    expiration {
      expired_object_delete_marker = true
    }

    noncurrent_version_expiration {
      noncurrent_days = 1
    }
  }
}

resource "null_resource" "empty_s3_bucket" {
  provisioner "local-exec" {
    command = <<EOT
      aws s3 rm s3://${aws_s3_bucket.my_bucket.bucket} --recursive
      versions_json=$(aws s3api list-object-versions --bucket ${aws_s3_bucket.my_bucket.bucket} --query='{Objects: Versions[].{Key:Key,VersionId:VersionId}}' --output json)
      if [ "$(echo $versions_json | jq '.Objects | length')" -gt 0 ]; then
        echo $versions_json | aws s3api delete-objects --bucket ${aws_s3_bucket.my_bucket.bucket} --delete file://-
      fi
    EOT
  }

  triggers = {
    bucket_name = aws_s3_bucket.my_bucket.id
  }
}

resource "aws_dynamodb_table" "my_table" {
  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name        = var.dynamodb_table_name
    Environment = "Dev"
  }
}