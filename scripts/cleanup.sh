#!/usr/bin/env bash
# Guided teardown in cost-safe reverse order (week4 -> week1). Warns about NAT/TGW/VPN/GA costs.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
echo "WARNING: NAT Gateway, TGW attachments, VPN, Client VPN, Global Accelerator, ALB, RDS bill per-hour. Destroy after evidence!"
for env in week4-monitoring week3-edge week2-hybrid week1-core; do
  if [ -d "$ROOT/terraform/environments/$env" ]; then
    echo "== destroy $env (10s to abort, Ctrl-C now to skip) =="
    sleep 10
    (cd "$ROOT/terraform/environments/$env" && terraform destroy -auto-approve || true)
  fi
done
echo "Also check: Client VPN endpoints, GA accelerators, snapshots, log buckets."
