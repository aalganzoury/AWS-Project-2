# IR Runbook — Compromised EC2 Instance

> Scope: lab / own account ONLY. Do NOT run against instances you do not own.
> Roles: IR lead, network, forensics. Replace `i-0123456789abcdef0` and `IR-EXAMPLE-001` with real incident values (in SNS/log, never commit secrets).

## 1. Detect
- GuardDuty finding / CW alarm (port scan, egress spike) / WAF block surge.
- Record: finding ARN, instance ID, AZ, SGs, time window (UTC), reporter.
```bash
aws ec2 describe-instances --instance-ids i-0123456789abcdef0
aws guardduty get-findings --detector-id <detector> --finding-ids <id>
```

## 2. Triage (5 min)
- Is it prod? Blast radius (SGs, IAM role, subnets, TGW reachability)?
- Tag suspect: `aws ec2 create-tags --resources i-XXX --tags Key=IncidentId,Value=IR-EXAMPLE-001 Key=Quarantine,Value=suspect`
- Start incident log (timestamp every action — `scripts/ir/isolate-instance.sh` does this automatically).

## 3. Contain / isolate (keep RUNNING for forensics — do NOT stop/terminate yet)
```bash
bash scripts/ir/isolate-instance.sh --incident IR-EXAMPLE-001 --instance-id i-0123456789abcdef0
# does: swap to quarantine SG (no ingress/egress), revoke session via deny policy, tag, log
```

## 4. Evidence (order of volatility: memory -> disk -> logs -> net)
```bash
bash scripts/ir/collect-evidence.sh --incident IR-EXAMPLE-001 --instance-id i-0123456789abcdef0
# does: EBS snapshots (tagged), flow-log export window, CloudTrail lookup, describe + SHA-256 manifest
```
- Memory capture note: SSM document `AWS-RunShellScript` with LiME/AVML ONLY if pre-approved in your lab; otherwise snapshot + note gap.
- Chain of custody: see `docs/evidence-collection-notes.md` template.

## 5. Eradicate
- Rotate credentials (Secrets Manager RDS password, instance role creds), revoke sessions, patch AMI, remove persistence (cron, systemd, authorized_keys — document before deleting).

## 6. Recover
- Replace from known-good AMI/ASG; re-attach correct SGs; verify health checks + alarms green; monitor 24h with Athena queries.

## 7. Lessons learned
- Fill `docs/final-secure-network-report.md` findings; file follow-up (SG tightening, new WAF rule, additional alarm).
