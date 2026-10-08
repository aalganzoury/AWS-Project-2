# Global Accelerator vs CloudFront

| | CloudFront (CDN) | Global Accelerator (anycast network) |
|---|---|---|
| What | Cache + edge security (WAF Shield) for HTTP/S | TCP/UDP static anycast IPs to regional endpoints (ALB/NLB/EIP) |
| Caching | YES (origin offload, lower latency for cacheable) | NO (always goes to origin, faster path only) |
| Protocols | HTTP/HTTPS/WebSocket | Any TCP/UDP (gaming, VoIP, custom) |
| DDoS | Absorbs + WAF CLOUDFRONT + Shield | Shield Advanced eligible, SYN proxy at edge |
| IPs | Dynamic edge pool | 2 static anycast IPs (allow-list friendly) |
| Cost | Per request + data out (cheap idle) | Per accelerator-hour + data transfer premium (costly idle — lab toggle OFF) |
| When to use | Web content, APIs with cache, WAF at edge | Non-HTTP, static-IP requirement, instant failover |

Lab: `enable_global_accelerator=false` default. Comparison test = curl via CF vs GA endpoint, record TTFB in `connectivity-test-results.md`.
