# S3 Backend Module

This module will deploy an S3 remote backend for Terraform

### Required Variables:

`principal_arn`: AWS principal arn allowed to assume the IAM role

### Optional Variables:

`namespace`: Defaults to s3backend. It will be the prefix of the S3 Bucket and DynamoDB table
`force_destroy_state`: Defaults to false. Allows deleting S3 bucket through terraform
`aws_region`: AWS Region to create resources in defaults to us-east-1
