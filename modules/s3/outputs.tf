output "bucket_names" {
  value = keys(aws_s3_bucket.this)
}

output "bucket_arns" {
  value = {
    for k, v in aws_s3_bucket.this : k => v.arn
  }
}