# IP Plan (single source of truth)

> All CIDRs are documentation / lab ranges. Never replace with real corporate ranges in git.
> Account ID placeholder: `111111111111`. Domain placeholder: `example.com`.
> Documentation IP for on-prem public side: `203.0.113.0/24` (TEST-NET-3, RFC 5737).

| VPC | CIDR | Purpose |
|-----|------|---------|
| Hub / shared-services | `10.0.0.0/16` | TGW hub, shared services, VPN attachment, inspection (optional) |
| Prod | `10.1.0.0/16` | Production workload (ALB + app + data) |
| Dev | `10.2.0.0/16` | Development workload (mirrors prod, smaller) |
| Simulated on-prem | `192.168.0.0/16` | Separate VPC acting as customer site (strongSwan gateway + test client) |

No overlapping CIDRs. All VPCs use 2 AZs (`<region>a`, `<region>b` — variables `azs`).

## Per-VPC subnet plan (consistent everywhere)

| Tier | Hub `10.0.0.0/16` | Prod `10.1.0.0/16` | Dev `10.2.0.0/16` | On-prem sim `192.168.0.0/16` | Route table | Notes |
|------|-------------------|--------------------|--------------------|------------------------------|-------------|-------|
| Public (2 AZs) | `10.0.10.0/24`, `10.0.11.0/24` | `10.1.10.0/24`, `10.1.11.0/24` | `10.2.10.0/24`, `10.2.11.0/24` | `192.168.10.0/24`, `192.168.11.0/24` | public-rt (0.0.0.0/0 -> IGW) | ALB / NAT GW / IGW only. No DB, no app with public IP. |
| Private app (2 AZs) | `10.0.20.0/24`, `10.0.21.0/24` | `10.1.20.0/24`, `10.1.21.0/24` | `10.2.20.0/24`, `10.2.21.0/24` | `192.168.20.0/24` (client) | app-rt (0.0.0.0/0 -> NAT; TGW/propagated routes per week) | EC2 app tier, SSM endpoints, no public IP. |
| Private data (2 AZs) | `10.0.30.0/24`, `10.0.31.0/24` | `10.1.30.0/24`, `10.1.31.0/24` | `10.2.30.0/24`, `10.2.31.0/24` | — | data-rt (no 0.0.0.0/0; local only + endpoints) | RDS / data stores only. No NAT, no IGW. |
| TGW / inspection attachment (2 AZs, /28) | `10.0.40.0/28`, `10.0.40.16/28` | `10.1.40.0/28`, `10.1.40.16/28` | `10.2.40.0/28`, `10.2.40.16/28` | — | tgw-attach-rt | Small subnets for TGW ENIs / inspection appliances. |

## Reserved / special
- VPC default CIDR base `.0` and `.1` (AWS reserved) — never assign.
- VPN BGP inside tunnel CIDRs: `169.254.0.0/16` (AWS-assigned per tunnel, documented in `docs/routing-documentation.md` after apply).
- Client VPN (optional): `10.10.0.0/22` client CIDR (must not overlap any VPC above).
- On-prem public IP placeholder: `203.0.113.12` (customer gateway IP variable default).

## Validation rule
After every `apply`, run `scripts/tests/test-segmentation.sh` and paste outputs into `docs/connectivity-test-results.md`.
