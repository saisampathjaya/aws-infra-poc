resource "aws_s3_bucket" "this" {

  for_each = toset(var.bucket_names)

  bucket = each.value

  tags = {
    Name        = each.value
    Environment = var.environment
  }
}