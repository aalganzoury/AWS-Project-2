# Week 4 — Network Monitoring, Detection & IR

## Objectives
VPC Flow Logs (S3 Parquet + CloudWatch), Traffic Mirroring (off by default), CloudWatch metric filters/alarms/dashboard, Athena analysis, GuardDuty (optional), compromised-instance IR simulation + isolation + evidence collection.

## Deploy
```bash
cd terraform/environments/week4-monitoring
cp terraform.tfvars.example terraform.tfvars
terraform init && terraform validate && terraform plan -out week4.tfplan
terraform apply week4.tfplan
# Athena queries
cat analysis/athena/*.sql
# IR drill (lab/own-account ONLY — see script headers)
bash scripts/ir/simulate-compromise.sh
bash scripts/ir/isolate-instance.sh --incident IR-EXAMPLE-001 --instance-id i-0123456789abcdef0
bash scripts/ir/collect-evidence.sh --incident IR-EXAMPLE-001 --instance-id i-0123456789abcdef0
```

## Modules
| Module | Notes |
|--------|-------|
| `flow-logs` | Parquet + Hive partitions + custom format (tcp-flags, pkt-srcaddr, flow-direction, traffic-path); CW Logs for metric filters; KMS + lifecycle bucket |
| `athena-flowlogs` | Workgroup (encrypted results) + Glue DB/table (partition projection) + named queries from `analysis/athena/` |
| `traffic-mirroring` | `enable_traffic_mirroring=false` default. Nitro-only, costly — documented |
| `monitoring` | Metric filters + alarms (SSH/RDP reject, scan, egress, NAT spike, VPN tunnel, ALB 5xx, WAF blocks) + SNS + dashboard |
| `guardduty` | Optional enable; findings used in IR lab |
| `ir-isolation` | Quarantine SG (no ingress/egress) + IR role policy + optional Lambda/EventBridge auto-isolate toggle |

## Deliverables
- [ ] Flow log queries (`docs/flow-log-queries.md` + `analysis/athena/`)
- [ ] Detection use cases (`docs/detection-use-cases.md`)
- [ ] IR runbook (`docs/incident-response-runbook-compromised-instance.md`)
- [ ] Evidence notes (`docs/evidence-collection-notes.md`)
- [ ] Final report (`docs/final-secure-network-report.md`)
