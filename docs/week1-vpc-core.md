# Week 1 — VPC Core Architecture

## Objectives
VPC with public/private subnets across 2 AZs, route tables, IGW, NAT Gateway, SSM access (no SSH from internet), EC2, ALB, RDS, security groups, NACLs, least privilege.

## Deploy
```bash
# 1. Backend placeholders (edit backend.tf first - S3 + DynamoDB, no real values in git)
# 2. Deploy core (one week at a time; destroy after capturing evidence)
cd terraform/environments/week1-core
cp terraform.tfvars.example terraform.tfvars   # fill placeholders only
terraform init
terraform validate
terraform plan -out week1.tfplan
terraform apply week1.tfplan
# 3. Test
bash scripts/tests/test-connectivity.sh
bash scripts/tests/test-segmentation.sh
```

## Modules used
| Module | Purpose |
|--------|---------|
| `modules/vpc` | VPC, subnets by tier, IGW, NAT (single or per-AZ toggle), route tables, locked-down default SG/NACL |
| `modules/nacl` | Tier NACLs (public/app/data) with explicit ephemeral rules (stateless!) |
| `modules/security-groups` | alb-sg, app-sg, db-sg, endpoint-sg — SG-to-SG references, no 0.0.0.0/0 except ALB 80/443 |
| `modules/ssm-access` | Instance profile (`AmazonSSMManagedInstanceCore`), interface endpoints, session logging; `enable_bastion=false` default |
| `modules/ec2-app` | Private EC2, IMDSv2 required, encrypted EBS, no public IP, user_data web app |
| `modules/alb` | Public ALB, HTTP->HTTPS redirect, ACM variable, access logs, drop invalid headers |
| `modules/rds` | Private subnets, KMS, managed master password (Secrets Manager), no public access, backups |

## Deliverables checklist
- [ ] VPC design + subnet/CIDR plan (`docs/ip-plan.md`)
- [ ] EC2/ALB/RDS deployed in private tiers
- [ ] SG/NACL rules matrix (`docs/security-groups-nacl-rules.md`)
- [ ] Architecture diagram (`docs/architecture.md`)
- [ ] Connectivity test results (`docs/connectivity-test-results.md`)
- [ ] Screenshots in `docs/evidence/` per `docs/evidence/README.md`

## Cost note
NAT Gateway is per-hour + per-GB. Single NAT for lab (`single_nat_gateway=true`); destroy after evidence. See `docs/cost-guardrails.md`.
