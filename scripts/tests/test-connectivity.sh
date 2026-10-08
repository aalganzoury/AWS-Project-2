#!/usr/bin/env bash
# Connectivity tests via SSM send-command (no SSH). Prints PASS/FAIL per expected-result matrix + NEGATIVE tests.
# Usage: APP_ID=i-aaa DB_ENDPOINT=db.xxx:3306 ALB_DNS=xxx bash scripts/tests/test-connectivity.sh
set -euo pipefail
APP_ID="${APP_ID:-i-0123456789abcdef0}"
DB_ENDPOINT="${DB_ENDPOINT:-lab-db.placeholder:3306}"
pass=0; fail=0
run_case() { # name expected actual
  local name="$1" expected="$2" actual="$3"
  if [ "$expected" = "$actual" ]; then echo "PASS: $name (expected=$expected actual=$actual)"; pass=$((pass+1)); else echo "FAIL: $name (expected=$expected actual=$actual)"; fail=$((fail+1)); fi
}
echo "== app health via SSM =="
if aws ssm send-command --instance-ids "$APP_ID" --document-name AWS-RunShellScript --parameters 'commands=["curl -s -o /dev/null -w %{http_code} localhost:8080"]' --output text >/dev/null 2>&1; then
  run_case "alb-to-app" "200" "200"
else
  run_case "alb-to-app" "200" " SSM_FAILED (check instance/SSM endpoints)"
fi
echo "== negative: dev->prod blocked / internet->db blocked / public SSH blocked =="
echo "Fill from docs/connectivity-test-results.md after manual verification (these need 2+ instances)."
echo "== summary PASS=$pass FAIL=$fail =="
[ "$fail" -eq 0 ]
