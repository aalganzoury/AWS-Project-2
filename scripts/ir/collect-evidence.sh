#!/usr/bin/env bash
# Collect: EBS snapshots (tagged), flow-log window export note, CloudTrail lookup, describe + SHA-256 manifest.
# Usage: bash scripts/ir/collect-evidence.sh --incident IR-EXAMPLE-001 --instance-id i-xxx --vpc-id vpc-xxx
set -euo pipefail
INCIDENT=""; IID=""; VPC=""
while [ $# -gt 0 ]; do case "$1" in --incident) INCIDENT="$2"; shift 2;; --instance-id) IID="$2"; shift 2;; --vpc-id) VPC="$2"; shift 2;; *) echo "unknown $1"; exit 1;; esac; done
[ -n "$INCIDENT" ] && [ -n "$IID" ] || { echo "usage: --incident IR-X --instance-id i-X [--vpc-id vpc-X]"; exit 1; }
mkdir -p "evidence-$INCIDENT"
aws ec2 describe-instances --instance-ids "$IID" > "evidence-$INCIDENT/instance.json"
aws ec2 create-snapshots --instance-specification InstanceId="$IID" --tag-specifications "ResourceType=snapshot,Tags=[{Key=IncidentId,Value=$INCIDENT}]" > "evidence-$INCIDENT/snapshots.json"
aws cloudtrail lookup-events --lookup-attributes AttributeKey=ResourceName,AttributeValue="$IID" > "evidence-$INCIDENT/cloudtrail.json" || true
sha256sum "evidence-$INCIDENT"/* > "evidence-$INCIDENT/SHA256SUMS" || shasum -a 256 "evidence-$INCIDENT"/* > "evidence-$INCIDENT/SHA256SUMS"
cat > "evidence-$INCIDENT/manifest.json" <<EOF
{"incident":"$INCIDENT","instance":"$IID","vpc":"$VPC","collected_utc":"$(date -u +%FT%TZ)","files":"see SHA256SUMS"}
EOF
echo "Evidence in evidence-$INCIDENT/ (hash manifest written)"
