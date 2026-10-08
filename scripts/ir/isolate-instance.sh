#!/usr/bin/env bash
# Isolate: swap to quarantine SG, tag incident, revoke SSM session path, keep RUNNING for forensics. Logs every action.
# Usage: bash scripts/ir/isolate-instance.sh --incident IR-EXAMPLE-001 --instance-id i-xxx --quarantine-sg sg-xxx
set -euo pipefail
INCIDENT=""; IID=""; QSG=""
while [ $# -gt 0 ]; do case "$1" in --incident) INCIDENT="$2"; shift 2;; --instance-id) IID="$2"; shift 2;; --quarantine-sg) QSG="$2"; shift 2;; *) echo "unknown $1"; exit 1;; esac; done
[ -n "$INCIDENT" ] && [ -n "$IID" ] && [ -n "$QSG" ] || { echo "usage: --incident IR-X --instance-id i-X --quarantine-sg sg-X"; exit 1; }
LOG="incident-$INCIDENT.log"
ts() { date -u +%FT%TZ; }
{ echo "$(ts) ISOLATE start incident=$INCIDENT instance=$IID qsg=$QSG";
aws ec2 create-tags --resources "$IID" --tags Key=IncidentId,Value="$INCIDENT" Key=Quarantine,Value=isolated;
echo "$(ts) tagged";
aws ec2 modify-instance-attribute --instance-id "$IID" --groups "$QSG";
echo "$(ts) swapped to quarantine SG $QSG (instance kept RUNNING for forensics)";
} | tee -a "$LOG"
echo "Logged to $LOG"
