output "distribution_id" { value = aws_cloudfront_distribution.this.id }
output "distribution_domain" { value = aws_cloudfront_distribution.this.domain_name }
output "origin_bucket" { value = aws_s3_bucket.origin.id }
