# Connectivity Options Comparison

| Option | Use case | Scaling | Transitive routing? | Cost drivers | Security notes |
|--------|----------|---------|---------------------|--------------|----------------|
| VPC peering | 2 VPCs, simple, same Org | Mesh explodes (n*(n-1)/2); no transitive | NO (non-transitive) | Data transfer (no hourly) | SGs + routes both sides; CIDRs must not overlap |
| Transit Gateway | Hub-and-spoke, many VPCs + hybrid | Thousands of attachments, segmented RTs | YES via TGW route tables | Per attachment-hour + per-GB processed | Segmentation via isolated TGW RTs; inspection VPC possible |
| PrivateLink (endpoint service) | One service -> many consumers, unidirectional | Per service, AZ ENIs | N/A (service, not routing) | Per endpoint-hour + per-GB | Consumer never reaches provider VPC; allow-list principals |
| Gateway endpoints (S3/DynamoDB) | Private S3/DDB without NAT | Free, per route table | N/A | Free (data transfer only) | Endpoint policy least privilege; no cross-region |
| Interface endpoints (PrivateLink) | Private AWS APIs / SSM / secrets | Per AZ ENI, per service | N/A | Per endpoint-hour + per-GB | Private DNS; endpoint SG 443 only |
| Site-to-Site VPN | Encrypted hybrid over internet | Per connection, 2 tunnels, ECMP with TGW | Via TGW/VGW routes | Per connection-hour + data out | IKEv2 + strong ciphers, PSK in Secrets Manager, tunnel logging |
| Client VPN | Remote users -> VPC | Per endpoint + per association-hour | Via authorization rules | Endpoint-hour + association-hour (expensive idle!) | Mutual TLS (ACM), split-tunnel, scoped auth rules, connection logging |
| Direct Connect | Dedicated/private hybrid, steady throughput | LAG, VIFs, resilient pairs | Via DX GW + TGW/VGW | Port-hour + per-GB (plus cross-connect) | Private/public/transit VIF; MACsec where supported; VPN backup |

See also `docs/direct-connect-concepts.md` and `docs/global-accelerator-vs-cloudfront.md`.
