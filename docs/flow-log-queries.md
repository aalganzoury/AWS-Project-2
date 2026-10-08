# Flow Log Queries (what each Athena query answers)

> Table: Glue `flowlogs` with partition projection over `s3://<logs-bucket>/AWSLogs/111111111111/vpcflowlogs/...`. Format includes `tcp-flags pkt-srcaddr flow-direction traffic-path`. See `modules/athena-flowlogs`.

| File | Question | Key filters |
|------|----------|-------------|
| `top-talkers.sql` | Who moves most bytes? | `sum(bytes)` group by `srcaddr,dstaddr`, window `day` |
| `rejected-traffic-by-port.sql` | What is being blocked, where? | `action='REJECT'` group by `dstport,protocol` |
| `ssh-rdp-attempts.sql` | Brute-force signal? | `dstport in (22,3389)` + `REJECT` count by src |
| `port-scan-detection.sql` | One source touching many ports? | `count(distinct dstport) > 20` per src per 5-min window |
| `data-exfiltration-large-egress.sql` | Unusual large egress? | `flow-direction='egress'`, top `bytes` to outside VPC CIDRs |
| `traffic-to-unusual-ports.sql` | C2-like ports? | dstport NOT in (80,443,8080,3306,53,123) + REJECT/ACCEPT review |
| `nat-gateway-top-destinations.sql` | Where is NAT egress going? | filter NAT ENI / `pkt-srcaddr`, group by dst |
| `vpn-and-tgw-traffic.sql` | Hybrid path verification? | `srcaddr/dstaddr` in `192.168.0.0/16` <-> `10.0.0.0/8`, `traffic-path` |

Run in Athena workgroup (encrypted results bucket). Paste result row counts into `final-secure-network-report.md`.
