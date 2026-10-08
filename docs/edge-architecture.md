# Edge Architecture

```mermaid
flowchart LR
    User((User)) --> DNS[Route 53<br/>optional zone]
    DNS --> CF[CloudFront distribution<br/>TLSv1.2_2021+, HTTP/2+3, compress]
    CF -->|Response security headers policy| WAF[WAF CLOUDFRONT<br/>Common+SQLi+BadInputs+Rep+Anon+rate]
    WAF --> OAC[Origin Access Control]
    OAC --> S3[(Private S3 bucket<br/>BlockPublicAccess, SSE, versioning)]
    CF -->|access logging| LogB[(Logging bucket)]
    ALB[Public ALB + WAF REGIONAL] -.->|alternate origin| CF
```

- S3 bucket policy allows ONLY the CloudFront service principal + distribution ARN (OAC). Direct S3 website/REST access = DENIED (tested in `test-edge-protections.sh`).
- Geo restriction variable (`none` default; `whitelist/blacklist` optional).
- Logging: CloudFront access logs + WAF logs (redacted fields) + S3 server access.
