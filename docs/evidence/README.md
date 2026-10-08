# Evidence — naming convention

Save screenshots + raw logs here. NEVER include real account IDs, emails, or public IPs you don't own (redact).

```
docs/evidence/
  week1-vpc-diagram-<date>.png
  week1-alb-to-app-<date>.log
  week1-app-to-db-<date>.log
  week1-nat-egress-<date>.log
  week1-ssh-blocked-<date>.log
  week2-tgw-routes-<date>.log
  week2-vpn-tunnels-<date>.log
  week2-dev-to-prod-blocked-<date>.log
  week3-cloudfront-ok-<date>.log
  week3-waf-block-<date>.log
  week3-security-headers-<date>.log
  week4-athena-query-<name>-<date>.csv
  week4-alarm-<name>-<date>.png
  ir-IR-EXAMPLE-001-manifest-<date>.json
```

Each log: first lines = date (UTC), region, `terraform version`, `aws --version`, command run.
