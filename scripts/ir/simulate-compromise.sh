#!/usr/bin/env bash
# LAB ONLY — OWN ACCOUNT ONLY. SAFE simulation: benign suspicious-LOOKING traffic only.
# Generates: repeated connections to blocked ports, DNS lookup of GuardDuty sample/test domain,
# and tags an instance as "compromised-sim". NO malware, NO real attack tooling, NO external targets.
# Usage: INSTANCE_ID=i-xxx bash scripts/ir/simulate-compromise.sh
set -euo pipefail
INSTANCE_ID="${INSTANCE_ID:-i-0123456789abcdef0}"
echo "[lab-only] Simulating benign suspicious patterns on $INSTANCE_ID (own account only)"
aws ssm send-command --instance-ids "$INSTANCE_ID" --document-name AWS-RunShellScript --parameters 'commands=["for p in 22 3389 3306 6379; do timeout 2 bash -c "</dev/tcp/127.0.0.1/$p" || true; done", "nslookup guardduty-test-lab.example.com || true"]' --output text || true
aws ec2 create-tags --resources "$INSTANCE_ID" --tags Key=CompromiseSim,Value=true || true
echo "Done. Now run isolate + collect scripts as IR drill."
