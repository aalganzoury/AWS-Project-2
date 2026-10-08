# Hybrid Connectivity Test Report (template)

Environment: week2-hybrid | Date: _fill_ | Tester: _fill_ | Profile/region: _fill (no account ID)_

## Tunnel status
```
aws ec2 describe-vpn-connections --vpn-connection-ids <vpn-id> --query 'VpnConnections[].VgwTelemetry'
# paste output; both tunnels UP expected (or 1/2 with single-cable lab note)
```

## Reachability (via SSM on on-prem sim client `192.168.20.x`)

| Test | Command | Expected | Actual | Result |
|------|---------|----------|--------|--------|
| on-prem -> hub app | `ping -c4 <hub-app-private-ip>` + `curl <hub-app>:8080` | OK via VPN/TGW | _fill_ | PASS/FAIL |
| on-prem -> prod app (if allowed) | `curl` | OK or BLOCKED per TGW policy (state which) | _fill_ | PASS/FAIL |
| prod -> on-prem | SSM send-command ping back | OK | _fill_ | PASS/FAIL |
| dev -> prod (negative) | `curl --connect-timeout 5 <prod-ip>:8080` | timeout/blocked | _fill_ | PASS/FAIL |
| BGP (if enabled) | `aws ec2 describe-vpn-connections` BGP status | ESTABLISHED | _fill_ | PASS/FAIL |

## Routing evidence
- Attach VPC route tables + TGW route tables (`aws ec2 describe-route-tables`, `aws ec2 search-transit-gateway-routes`).
- Save under `docs/evidence/week2-vpn-<date>.log`.

## Findings / follow-ups
_fill_
