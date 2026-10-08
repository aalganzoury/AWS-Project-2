# Cost Guardrails (read before apply!)

> Prices change — check the AWS pricing pages. Below: WHAT costs money and per-hour drivers.

| Service | Driver | Lab rule |
|---------|--------|----------|
| NAT Gateway | per-hour + per-GB processed | single NAT (`single_nat_gateway=true`); destroy after week1 evidence |
| Transit Gateway | per attachment-hour + per-GB processed | only week2/full; delete attachments promptly |
| Site-to-Site VPN | per connection-hour (+ data out) | only while testing hybrid; delete after report |
| Client VPN | per endpoint-hour + per association-hour | default OFF; enable minutes only |
| ALB | per-hour (LCU) | destroy with week env |
| RDS | per-hour + storage + backups | smallest instance, stop/delete after evidence |
| Global Accelerator | per-hour + data premium | default OFF |
| WAF | per WebACL-month + per-million requests | keep 1 ACL per scope in lab; delete after |
| Traffic Mirroring | per ENI-hour + mirrored GB | default OFF |
| VPC endpoints (Interface) | per endpoint-hour + per-GB | minimal list; delete after |
| Flow Logs -> S3/CW | ingestion + storage | short retention, lifecycle to expire |

**Deploy one week at a time and destroy after capturing evidence:**
```bash
terraform destroy -auto-approve   # per environment, reverse order: week4 -> week1
bash scripts/cleanup.sh           # guided order with cost warnings
```
