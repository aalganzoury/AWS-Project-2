# Week 2 — Advanced Connectivity & Hybrid Networking

## Objectives
VPC peering (non-transitive), VPC endpoints, PrivateLink, Transit Gateway hub-and-spoke with segmentation, Site-to-Site VPN to a simulated on-prem VPC, Client VPN (optional/off), Direct Connect concepts (no circuits).

## Deploy
```bash
cd terraform/environments/week2-hybrid
cp terraform.tfvars.example terraform.tfvars
terraform init && terraform validate && terraform plan -out week2.tfplan
terraform apply week2.tfplan
bash scripts/tests/test-vpn-and-routing.sh
bash scripts/tests/test-segmentation.sh
```

## Key designs
- **Peering lab**: prod<->hub peering + routes both sides; document non-transitive (prod cannot reach dev via hub).
- **Endpoints**: Gateway (S3, DynamoDB) + Interface (ssm, ssmmessages, ec2messages, logs, secretsmanager) with private DNS + restrictive endpoint policies.
- **PrivateLink**: provider NLB + endpoint service (allowed principals) / consumer interface endpoint in another VPC.
- **TGW**: attachments for hub/prod/dev; SEPARATE TGW route tables — prod and dev reach hub only, NOT each other. Propagation vs static documented in module comments. Optional inspection VPC pattern documented (not deployed by default).
- **Site-to-Site VPN**: customer gateway (public IP placeholder `203.0.113.12`), VPN to TGW (VGW toggle), static/BGP toggle, IKEv2 + strong ciphers, tunnel logging to CloudWatch.
- **On-prem simulator**: separate VPC `192.168.0.0/16` with strongSwan/Libreswan instance (user_data from VPN outputs) + test client. LAB ONLY. Destroy after lab.
- **Client VPN**: disabled by default (`enable_client_vpn=false`). Mutual TLS via ACM ARNs (easy-rsa documented), split-tunnel, connection logging. Cost warning.
- **Direct Connect**: concepts only (`docs/direct-connect-concepts.md`). No Terraform for physical circuits.

## Deliverables
- [ ] Hub-and-spoke/TGW diagram (`docs/architecture.md`)
- [ ] Peering/endpoint setup + route table docs (`docs/routing-documentation.md`)
- [ ] VPN config + hybrid test report (`docs/hybrid-connectivity-test-report.md`)
- [ ] Comparison table (`docs/connectivity-options-comparison.md`)
