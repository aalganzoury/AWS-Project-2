# Week 3 — Edge Security, WAF, DDoS & Content Delivery

## Objectives
CloudFront + private S3 origin (OAC), WAF (CloudFront + ALB), Shield concepts, Firewall Manager concepts, Route 53 health checks, Global Accelerator comparison (optional/off).

## Deploy
```bash
cd terraform/environments/week3-edge
cp terraform.tfvars.example terraform.tfvars
terraform init && terraform validate && terraform plan -out week3.tfplan
terraform apply week3.tfplan
bash scripts/tests/test-edge-protections.sh
```

## Modules
| Module | Notes |
|--------|-------|
| `cloudfront-s3` | Private S3 + OAC, block public access, versioning, SSE, TLS1.2+, security headers policy, access logging, geo restriction var |
| `waf-cloudfront` | WAFv2 CLOUDFRONT scope — MUST use `provider aws.useast1` (us-east-1 alias). Managed groups: Common, KnownBadInputs, SQLi, IP reputation, Anonymous IP. Rate rule + custom header/path/geo examples. Logging with sensitive-field redaction. |
| `waf-alb` | WAFv2 REGIONAL for ALB, same pattern |
| `route53-health` | `enable_dns=false` default (no hosted zone without your domain). Health checks + CW alarm + SNS + failover record example |
| `global-accelerator` | `enable_global_accelerator=false` default. Comparison lab only — costs per hour |

## Deliverables
- [ ] CloudFront + S3 lab (`docs/edge-architecture.md`)
- [ ] WAF rule set (module READMEs + this doc)
- [ ] DDoS mitigation plan (`docs/ddos-mitigation-plan.md`)
- [ ] Edge architecture (`docs/edge-architecture.md`)
- [ ] Route 53 / health check design (`docs/route53-healthcheck-design.md`)
- [ ] Global Accelerator vs CloudFront (`docs/global-accelerator-vs-cloudfront.md`)
- [ ] Firewall Manager concepts (`docs/firewall-manager-concepts.md`)
