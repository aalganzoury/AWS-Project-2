# Security Groups & NACL Rules Matrix

> SGs are stateful; NACLs are stateless — you MUST allow ephemeral return traffic (1024-65535) explicitly on NACLs.
> Prefer SG-to-SG references over CIDRs. No `0.0.0.0/0` ingress except ALB 80/443.

## Security groups

| SG | Ingress (source -> port/proto) | Egress | Justification |
|----|-------------------------------|--------|---------------|
| alb-sg | `0.0.0.0/0` -> 80/tcp (ALB public HTTP, redirects to 443); `0.0.0.0/0` -> 443/tcp (ALB public HTTPS) | app-sg 8080/tcp (or 80/443 to targets); 443 to endpoints where needed | Only public entry point; WAF REGIONAL attached; drop invalid headers |
| app-sg | alb-sg -> 8080/tcp (app); endpoint-sg -> 443/tcp (return/SSM — usually egress); on-prem `192.168.0.0/16` -> 8080/tcp ONLY via TGW/VPN where required | db-sg 3306/tcp (MySQL) / 5432 (Postgres, pick one); 443 to S3/endpoints via gateway/interface; 80/443 egress via NAT (patching) | No internet ingress; SG reference enforces least privilege |
| db-sg | app-sg -> 3306/tcp (or 5432) | none (or DNS/endpoints as needed) | DB reachable only from app tier |
| bastion/ssm-sg | none from internet (SSM Session Manager, no SSH open) | 443 to SSM endpoints | Admin via SSM only; `enable_bastion=false` default with justification in module |
| endpoint-sg | app-sg / VPC CIDR -> 443/tcp | none | Interface endpoints (SSM, logs, secrets) private only |

## NACLs (stateless — both directions required)

### public NACL
| # | Dir | Proto | Port | Src/Dst | Allow/Deny | Purpose |
|---|-----|-------|------|---------|------------|---------|
| 100 | ingress | tcp | 80 | 0.0.0.0/0 | ALLOW | ALB HTTP |
| 110 | ingress | tcp | 443 | 0.0.0.0/0 | ALLOW | ALB HTTPS |
| 120 | ingress | tcp | 1024-65535 | 0.0.0.0/0 | ALLOW | Ephemeral return for outbound |
| 32767 | ingress | all | all | 0.0.0.0/0 | DENY | Explicit deny (default deny) |
| 100 | egress | tcp | 80 | 0.0.0.0/0 | ALLOW | Outbound HTTP (updates/responses) |
| 110 | egress | tcp | 443 | 0.0.0.0/0 | ALLOW | Outbound HTTPS |
| 120 | egress | tcp | 8080 | app subnets | ALLOW | To app targets |
| 130 | egress | tcp | 1024-65535 | 0.0.0.0/0 | ALLOW | Ephemeral return |
| 32767 | egress | all | all | 0.0.0.0/0 | DENY | Default deny |

### app NACL
| # | Dir | Proto | Port | Src/Dst | Allow/Deny | Purpose |
|---|-----|-------|------|---------|------------|---------|
| 100 | ingress | tcp | 8080 | public subnets | ALLOW | From ALB only |
| 110 | ingress | tcp | 443 | VPC CIDR | ALLOW | SSM/endpoints |
| 120 | ingress | tcp | 1024-65535 | 0.0.0.0/0 | ALLOW | Ephemeral return (NAT/RDS responses) |
| 32767 | ingress | all | all | 0.0.0.0/0 | DENY | Deny rest |
| 100 | egress | tcp | 3306 | data subnets | ALLOW | To RDS |
| 110 | egress | tcp | 443 | 0.0.0.0/0 | ALLOW | HTTPS via NAT/endpoints |
| 120 | egress | tcp | 1024-65535 | 0.0.0.0/0 | ALLOW | Ephemeral return |
| 32767 | egress | all | all | 0.0.0.0/0 | DENY | Deny rest |

### data NACL
| # | Dir | Proto | Port | Src/Dst | Allow/Deny | Purpose |
|---|-----|-------|------|---------|------------|---------|
| 100 | ingress | tcp | 3306 | app subnets | ALLOW | MySQL from app only (or 5432) |
| 110 | ingress | tcp | 1024-65535 | app subnets | ALLOW | Ephemeral return |
| 32767 | ingress | all | all | 0.0.0.0/0 | DENY | Deny rest |
| 100 | egress | tcp | 1024-65535 | app subnets | ALLOW | Return traffic only |
| 32767 | egress | all | all | 0.0.0.0/0 | DENY | No internet |

Terraform: `terraform/modules/nacl` implements the above; `terraform/modules/security-groups` implements SGs.
