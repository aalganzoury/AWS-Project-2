# Final Secure Network Report (template)

## 1. Summary
_fill: goal, weeks deployed, dates, region (no account ID)_

## 2. Architecture
Link `docs/architecture.md` + IP plan (`docs/ip-plan.md`). Decisions: single NAT (cost), TGW segmentation (prod/dev isolated), SSM-only admin, WAF both scopes, flow logs Parquet + CW.

## 3. Decisions log
| Decision | Alternatives | Why |
|----------|-------------|-----|
| _fill_ | _fill_ | _fill_ |

## 4. Test results
Link `docs/connectivity-test-results.md` + `docs/hybrid-connectivity-test-report.md`. Paste PASS/FAIL table.

## 5. Findings (security)
| # | Severity | Finding | Evidence | Remediation |
|---|----------|---------|----------|-------------|
| 1 | _fill_ | _fill_ | _fill_ | _fill_ |

## 6. Cost
Hours each env ran, biggest drivers (NAT/TGW/VPN), total estimate + cleanup confirmation (`terraform destroy` outputs).

## 7. Lessons learned
_fill: what broke, what you'd automate, what needs Organizations/real domain for prod._
