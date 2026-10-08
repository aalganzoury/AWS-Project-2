# Detection Use Cases

| Use case | Data source | Query / metric filter | Alarm | Response |
|----------|-------------|----------------------|-------|----------|
| SSH/RDP brute force | Flow Logs (REJECT 22/3389) + CW filter | `ssh-rdp-attempts.sql` / filter `{ $.dstport=22 }` | >10 rejects/5min -> SNS | Review SG/NACL, confirm SSM-only, isolate if lateral |
| Port scan | Flow Logs | `port-scan-detection.sql` (>20 ports/5min/src) | CW alarm or Athena scheduled | Block src in WAF/NACL temp, IR triage |
| Unusual egress / exfil | Flow Logs + NAT bytes | `data-exfiltration-large-egress.sql`, `NatGatewayBytesOutToDestination` spike | Anomaly alarm | Snapshot + isolate per IR runbook |
| Internet -> DB attempt | Flow Logs REJECT to 3306 from outside app | `rejected-traffic-by-port.sql` filtered 3306 | Immediate SNS | Verify db-sg, rotate creds if ACCEPT seen |
| VPN tunnel down | VPN telemetry | `TunnelState=0` metric filter | Alarm -> SNS | Failover check, on-prem sim gateway restart |
| ALB 5xx surge | ALB access + CW | `HTTPCode_Target_5XX_Count` | >threshold | Check targets, WAF blocks, deploy rollback |
| WAF block spike | WAF logs | `BlockedRequests` rate | Spike alarm | Tune rate rule, review false positives |
| GuardDuty finding (opt) | GuardDuty | `UnauthorizedAccess:IAMUser/*`, `Backdoor:EC2/*` | EventBridge -> SNS/Lambda isolate | Full IR runbook |
