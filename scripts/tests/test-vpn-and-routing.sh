#!/usr/bin/env bash
# Hybrid tests: tunnel status + on-prem sim -> hub/prod reachability.
# Usage: VPN_ID=vpn-xxx ONPREM_CLIENT=i-xxx HUB_APP_IP=10.0.20.10 bash scripts/tests/test-vpn-and-routing.sh
set -euo pipefail
VPN_ID="${VPN_ID:-vpn-0123456789abcdef0}"
ONPREM_CLIENT="${ONPREM_CLIENT:-i-0123456789abcdef0}"
HUB_APP_IP="${HUB_APP_IP:-10.0.20.10}"
echo "== tunnel telemetry =="
aws ec2 describe-vpn-connections --vpn-connection-ids "$VPN_ID" --query 'VpnConnections[].VgwTelemetry' --output table || true
echo "== on-prem -> hub reachability via SSM =="
aws ssm send-command --instance-ids "$ONPREM_CLIENT" --document-name AWS-RunShellScript --parameters "commands=["ping -c4 -W2 $HUB_APP_IP", "curl -s -m 5 http://$HUB_APP_IP:8080 || true"]" --output text || true
echo "Save output to docs/evidence/week2-vpn-$(date -u +%F).log"
