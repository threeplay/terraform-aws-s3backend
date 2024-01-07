provider "aws" {
  region = var.aws_region
}

resource "aws_resourcegroups_group" "resourcegroups_group" {
  name = "${var.namespace}-group"

  resource_query {
    query = jsonencode({
      ResourceTypeFilters : ["AWS::AllSupported"],
      TagFilters : [{ Key : "ResourceGroup", Values : [var.namespace] }]
    })
  }
}

resource "random_string" "rand" {
  length  = 8
  special = false
  upper   = false
}

resource "aws_kms_key" "kms_key" {
  tags = {
    ResourceGroup = var.namespace
  }
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = "${var.namespace}-state-bucket-${random_string.rand.result}"

  force_destroy = var.force_destroy_state

  tags = {
    ResourceGroup = var.namespace
  }
}

resource "aws_s3_bucket_versioning" "s3_bucket_versioning" {
  bucket = aws_s3_bucket.s3_bucket.bucket

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_bucket_sse" {
  bucket = aws_s3_bucket.s3_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.kms_key.arn
    }
  }
}

resource "aws_dynamodb_table" "dynamodb_table" {
  hash_key = "LockID"
  name     = "${var.namespace}-state-lock"

  attribute {
    name = "LockID"
    type = "S"
  }

  read_capacity  = 1
  write_capacity = 1

  tags = {
    ResourceGroup = var.namespace
  }
}
