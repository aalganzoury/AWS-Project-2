# Connectivity Test Results (template)

> Fill after running `scripts/tests/test-connectivity.sh` and `test-segmentation.sh`.
> Save raw logs under `docs/evidence/` per naming convention.

| # | Test | Source -> Dest | Expected | Actual | Result | Evidence file |
|---|------|---------------|----------|--------|--------|---------------|
| 1 | ALB -> app | ALB -> private EC2:8080 via SSM curl | 200 OK | _fill_ | PASS/FAIL | `week1-alb-to-app-<date>.log` |
| 2 | App -> DB | EC2 -> RDS:3306 (nc) | reachable | _fill_ | PASS/FAIL | `week1-app-to-db-<date>.log` |
| 3 | App -> internet via NAT | EC2 curl https://example.com | 200 (via NAT) | _fill_ | PASS/FAIL | `week1-nat-egress-<date>.log` |
| 4 | NEGATIVE dev -> prod | dev EC2 -> prod app IP | blocked/timeout | _fill_ | PASS/FAIL | `week2-dev-to-prod-blocked-<date>.log` |
| 5 | NEGATIVE internet -> db | internet -> RDS | blocked | _fill_ | PASS/FAIL | `week1-internet-to-db-<date>.log` |
| 6 | NEGATIVE public SSH | internet -> EC2:22 | blocked (SSM only) | _fill_ | PASS/FAIL | `week1-ssh-blocked-<date>.log` |
| 7 | Endpoints | EC2 -> S3 via gateway endpoint | OK without IGW | _fill_ | PASS/FAIL | `week2-endpoint-<date>.log` |

Paste `PASS/FAIL` summary + `aws` + `terraform version` at top of each evidence log.
