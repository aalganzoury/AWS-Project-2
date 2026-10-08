#!/usr/bin/env bash
# Segmentation: prod/dev isolation + NACL sanity. Extend with your instance IDs.
set -euo pipefail
echo "== expected: dev->prod BLOCKED =="
echo "Run from dev instance: curl --connect-timeout 5 http://<prod-app-ip>:8080 (expect timeout)"
echo "== expected: app->db OK, internet->db BLOCKED, SSH from internet BLOCKED =="
echo "Record results in docs/connectivity-test-results.md"
