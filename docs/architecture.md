# Architecture

## Overall architecture

```mermaid
flowchart TB
    Internet((Internet)) --> CF[CloudFront + WAF<br/>scope CLOUDFRONT us-east-1]
    CF -->|OAC, private S3 only| S3[(S3 origin<br/>private + OAC)]
    Internet --> ALB[Public ALB<br/>80/443 only + WAF REGIONAL]
    ALB --> AppT[Private EC2 app tier<br/>IMDSv2, no public IP, SSM only]
    AppT --> DB[(RDS private<br/>app-sg only, KMS, Secrets Manager)]
    AppT -.->|Gateway/Interface endpoints| VPCE[(VPC endpoints<br/>S3/DynamoDB/SSM)]
    ProdVPC[Prod VPC 10.1.0.0/16] --- TGW[Transit Gateway<br/>segmented route tables]
    DevVPC[Dev VPC 10.2.0.0/16] --- TGW
    HubVPC[Hub VPC 10.0.0.0/16] --- TGW
    TGW --- VPN[Site-to-Site VPN<br/>to TGW, BGP/static]
    VPN --- OnPrem[Simulated on-prem VPC 192.168.0.0/16<br/>strongSwan gateway]
    PL[PrivateLink provider<br/>NLB + endpoint service] --- TGW
    Mon[Flow Logs -> S3 Parquet + CW Logs<br/>Athena + CloudWatch alarms + SNS] -.-> ProdVPC
    Mon -.-> HubVPC
```

## Week 1 — VPC core

```mermaid
flowchart LR
    IGW[IGW] --- Pub[Public subnets<br/>ALB + NAT]
    Pub --> NAT[NAT GW]
    NAT --> AppRT[Private app subnets<br/>EC2 via SSM]
    AppRT --> DataRT[Private data subnets<br/>RDS, no internet]
    NACL[NACLs per tier<br/>+ ephemeral 1024-65535] -.-> Pub
    NACL -.-> AppRT
    NACL -.-> DataRT
```

## Week 2 — Hub-and-spoke TGW + hybrid VPN

```mermaid
flowchart TB
    Prod[Prod 10.1.0.0/16] --- TGW[Transit Gateway]
    Dev[Dev 10.2.0.0/16] --- TGW
    Hub[Hub 10.0.0.0/16<br/>shared services] --- TGW
    TGW --- VPN[VPN attachment]
    VPN --- CGW[Customer gateway<br/>on-prem sim 203.0.113.12]
    CGW --- OnPrem[On-prem sim VPC 192.168.0.0/16]
    subgraph Segmentation ["TGW route tables (isolated)"]
      RTProd[prod-rt: -> hub only]
      RTDev[dev-rt: -> hub only]
      RTHub[hub-rt: -> prod + dev + vpn]
    end
```

> Peering is non-transitive (week2 lab). TGW solves transitive hub-and-spoke. Prod <-> Dev is BLOCKED by design.

## Week 3 — Edge / CloudFront

```mermaid
flowchart LR
    User((User)) --> R53[Route 53<br/>health checks + failover]
    R53 --> CF[CloudFront<br/>TLS1.2+, security headers, OAC]
    CF --> WAF[WAF managed + rate rules]
    WAF --> S3[(Private S3)]
    User -.->|comparison lab| GA[Global Accelerator<br/>optional, disabled]
    GA -.-> ALB[ALB origin]
```

## Week 4 — Monitoring / IR flow

```mermaid
flowchart TB
    VPC[VPC Flow Logs<br/>S3 Parquet + CW Logs] --> Athena[Athena + Glue<br/>partition projection]
    VPC --> Filters[Metric filters<br/>SSH/RDP reject, scan, egress, 5xx, WAF]
    Filters --> Alarms[CloudWatch alarms] --> SNS[(SNS topic)]
    GD[GuardDuty findings<br/>optional] --> EB[EventBridge + Lambda<br/>toggle] --> QSG[Quarantine SG<br/>no ingress/egress]
    IR[IR runbook:<br/>detect->triage->isolate->evidence->eradicate->recover] -.-> QSG
```
