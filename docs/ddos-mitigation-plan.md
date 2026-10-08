# DDoS Mitigation Plan

## Shield Standard vs Advanced (concepts)
- **Standard** (automatic, free): SYN/UDP floods, reflection mitigation at edge for all customers.
- **Advanced** (paid, $$$): larger guarantees, DRT access, cost protection (credits for scaling during attack), ALB/NLB/Global Accelerator/CLB + EIP coverage. Enable ONLY if you accept cost + have Organizations/billing contact.

## Layered defense (this repo)
1. **Edge absorption**: CloudFront + Route 53 (Anycast, massive edge capacity).
2. **Filtering**: WAF rate-based rules (e.g. 2000 req/5min/IP — tune), managed IP reputation + Anonymous IP lists, geo blocks where justified.
3. **Origin protection**: ALB hardened (drop invalid headers), only CloudFront/ALB public; origins never directly routable; S3 private via OAC.
4. **Scaling + throttling**: ALB target health, app autoscaling (lab: fixed count), API throttling where applicable.

## Runbook (suspected DDoS)
1. Confirm: CloudWatch (WAF blocked spike, ALB 5xx/surge, CF origin latency) + Athena (top-talkers).
2. Tighten WAF rate rule temporarily; add targeted geo/header block (document incident ID).
3. Engage AWS Support/DRT (Advanced only); consider CF cache TTL increase + origin shield.
4. Preserve logs (flow logs, WAF logs, ALB access logs — hash + manifest per `evidence-collection-notes.md`).
5. Post-mortem + cost review (cost-protection note: Advanced may credit scaling costs — file promptly).

## Cost-protection note
Without Advanced, scaling costs during an attack are yours. Lab rule: keep rate limits tight, destroy edge lab after evidence.
