# Evidence Collection Notes

## Order of volatility
1. Memory (process, connections) — most volatile. 2. Disk (EBS snapshot). 3. Network (flow logs, mirroring PCAP if enabled). 4. Logs (CloudTrail, CW Logs, WAF/ALB access). 5. Config (SGs, routes, IAM).

## Snapshots
```bash
aws ec2 create-snapshots --instance-specification InstanceId=i-0123456789abcdef0 --tag-specifications 'ResourceType=snapshot,Tags=[{Key=IncidentId,Value=IR-EXAMPLE-001}]'
```

## Flow logs / CloudTrail window
```bash
aws ec2 describe-flow-logs --filter Name=resource-id,Values=vpc-0123456789abcdef0
aws cloudtrail lookup-events --lookup-attributes AttributeKey=ResourceName,AttributeValue=i-0123456789abcdef0 --start-time 2026-01-01T00:00:00Z --end-time 2026-01-01T02:00:00Z
```

## Memory capture note
Use pre-staged SSM document + AVML/LiME only on Nitro instances you own; record tool version + hashes; if unavailable, note as gap.

## Hashing
```bash
sha256sum evidence/* > evidence/SHA256SUMS
```

## Chain of custody template
| Item | Collected by | UTC time | Source (ID) | Hash (SHA-256) | Storage | Handover to / time |
|------|-------------|----------|-------------|----------------|---------|-------------------|
| _fill_ | _fill_ | _fill_ | _fill_ | _fill_ | S3 `s3://evidence-bucket/IR-EXAMPLE-001/` (SSE-KMS) | _fill_ |
