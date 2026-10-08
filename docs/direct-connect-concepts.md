# Direct Connect Concepts (CONCEPT ONLY — no Terraform for physical circuits)

> You cannot provision physical DX circuits with Terraform in a portfolio lab. This doc is conceptual for interviews.

- **Private VIF**: private subnets via VGW/DX GW. **Public VIF**: public AWS services via public IPs. **Transit VIF**: DX GW -> TGW for multi-VPC.
- **LAG**: bundle connections for bandwidth + resilience.
- **Resiliency models**: single connection (dev only); dual connections same location; dual locations (production: 2 DX locations, 2 routers each).
- **DX + VPN backup**: IPsec VPN over internet as failover for DX (BGP preferred paths, BFD).
- **MACsec note**: point-to-point encryption at L2 where supported (location + device dependent); otherwise rely on IPsec/TLS above DX (DX alone is private, not encrypted).
- **Interview line**: "For steady >1Gbps or compliance-private hybrid, DX via DX GW to TGW with dual locations; VPN backup with BGP; MACsec if available."
