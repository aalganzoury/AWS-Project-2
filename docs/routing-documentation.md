# Routing Documentation (fill per environment)

> Every route table: name, associated subnets, routes, purpose. Update after each apply.

## Week 1 — core VPC (example: prod `10.1.0.0/16`)

| Route table | Associated subnets | Routes | Purpose |
|-------------|-------------------|--------|---------|
| prod-public-rt | `10.1.10.0/24`, `10.1.11.0/24` | `10.1.0.0/16` local; `0.0.0.0/0` -> IGW | Public ALB/NAT |
| prod-app-rt | `10.1.20.0/24`, `10.1.21.0/24` | local; `0.0.0.0/0` -> NAT GW | App egress via NAT only |
| prod-data-rt | `10.1.30.0/24`, `10.1.31.0/24` | local only | Isolated data, no internet |
| prod-tgw-attach-rt | `10.1.40.0/28`, `10.1.40.16/28` | local (+ TGW propagated in week2) | TGW ENIs |

## Week 2 — TGW + peering + VPN

| Route table | Associations | Routes | Purpose |
|-------------|-------------|--------|---------|
| tgw-prod-rt (TGW) | prod attachment | `10.0.0.0/16` -> hub attachment; `192.168.0.0/16` -> vpn attachment (if allowed); NO `10.2.0.0/16` | Prod reaches hub/on-prem, NOT dev |
| tgw-dev-rt (TGW) | dev attachment | `10.0.0.0/16` -> hub; NO prod | Dev reaches hub only |
| tgw-hub-rt (TGW) | hub + vpn attachments | `10.1.0.0/16` -> prod; `10.2.0.0/16` -> dev; `192.168.0.0/16` -> vpn | Hub reaches all spokes |
| peering-prod-to-hub | prod app subnets | `10.0.0.0/16` -> pcx-xxxx | Peering lab (non-transitive note) |
| vpn static/BGP | TGW/vpn attachment | `192.168.0.0/16` static or BGP propagated; tunnels `169.254.x.x/30` | Hybrid |

> Propagation vs static: propagation auto-inserts attached VPC CIDRs (convenient, less control); static gives explicit segmentation (preferred for prod/dev isolation). See `modules/transit-gateway` comments.
