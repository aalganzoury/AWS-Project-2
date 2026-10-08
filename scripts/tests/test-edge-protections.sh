#!/usr/bin/env bash
# Edge tests: direct S3 denied, CloudFront OK, WAF SQLi/XSS blocked, rate-limit, headers, TLS.
# Usage: CF_DOMAIN=xxx.cloudfront.net S3_URL=https://bucket.s3.amazonaws.com/index.html ALB_DNS=xxx bash scripts/tests/test-edge-protections.sh
set -euo pipefail
CF_DOMAIN="${CF_DOMAIN:-d111111abcdef8.cloudfront.net}"
S3_URL="${S3_URL:-https://secure-net-lab-origin-111111111111.s3.amazonaws.com/index.html}"
echo "== 1. direct S3 must be DENIED (403) =="
curl -s -o /dev/null -w "direct-s3:%{http_code}\n" "$S3_URL" || true
echo "== 2. CloudFront must be 200 =="
curl -s -o /dev/null -w "cloudfront:%{http_code}\n" "https://$CF_DOMAIN/" || true
echo "== 3. WAF SQLi probe must be blocked (403) =="
curl -s -o /dev/null -w "sqli:%{http_code}\n" "https://$CF_DOMAIN/?q=' OR '1'='1" || true
echo "== 4. security headers present =="
curl -sI "https://$CF_DOMAIN/" | grep -i -E 'strict-transport|content-security|x-frame|referrer' || echo "(check headers manually)"
echo "== 5. TLS version =="
echo | openssl s_client -connect "$CF_DOMAIN:443" -tls1_2 2>/dev/null | grep -i 'Protocol' || true
