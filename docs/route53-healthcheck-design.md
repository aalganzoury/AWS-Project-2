# Route 53 Health Check Design

> `enable_dns=false` default — health checks work without owning a domain; hosted zone/records only when you provide `domain_name`.

## Health check types
- **Endpoint**: HTTP/HTTPS/TCP to ALB or CloudFront origin (path `/health`, port 80/443/8080, interval 30s, failure threshold 3).
- **Calculated**: AND/OR of endpoint checks (e.g. 2 AZs must pass).
- **CloudWatch alarm-based**: invert alarm state into routing decision.

## Routing policies compared
| Policy | Behavior | Use in lab |
|--------|----------|------------|
| Failover (primary/secondary) | Health-checked active/passive | ALB primary -> static S3 page secondary (example in module) |
| Latency-based | Lowest latency region | Multi-region extension (documented, single region deployed) |
| Weighted | Traffic % split | Blue/green test (0/100 default) |

## Alarms
Health check -> CloudWatch alarm (`HealthyHostCount < 1`) -> SNS topic. See `modules/monitoring` + `modules/route53-health`.

## Variables
`domain_name` (e.g. `app.example.com`), `hosted_zone_id` (existing), `enable_dns`. Never commit a real domain you own with production traffic — use a lab subdomain.
