#!/usr/bin/env bash
# fmt -check + init -backend=false + validate for every module and environment. No AWS credentials needed.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
echo "== terraform fmt -check =="
terraform fmt -check -recursive "$ROOT/terraform"
echo "== validate modules =="
for d in "$ROOT"/terraform/modules/*/; do
  # WHY skip: waf-cloudfront declares configuration_aliases [aws.useast1];
  # standalone validate has no aliased provider config by design.
  # It is validated in context via environments (week3-edge, full).
  if [[ "$d" == *"waf-cloudfront"* ]]; then
    echo "-- $d (skipped standalone: needs aws.useast1 alias; covered by env validation)"
    continue
  fi
  echo "-- $d"
  (cd "$d" && terraform init -backend=false -input=false >/dev/null && terraform validate)
done
echo "== validate environments =="
for d in "$ROOT"/terraform/environments/*/; do
  echo "-- $d"
  (cd "$d" && terraform init -backend=false -input=false >/dev/null && terraform validate)
done
echo "ALL VALIDATIONS PASSED"
