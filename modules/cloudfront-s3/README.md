# cloudfront-s3 module
Private S3 + OAC + security headers + geo restriction var + access logging hook.
```hcl
module "edge" { source = "../../modules/cloudfront-s3" }
```
Direct S3 access must be DENIED; CloudFront OK (tested in test-edge-protections.sh).
