output "config" {
  value = {
    bucket = aws_s3_bucket.s3_bucket.bucket
    region = var.aws_region
    dynamodb_table_name = aws_dynamodb_table.dynamodb_table.name
    role_arn = aws_iam_role.iam_role.arn
  }
}
