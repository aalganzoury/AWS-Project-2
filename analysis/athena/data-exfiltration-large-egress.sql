-- Large egress to outside VPC CIDRs (possible exfil; tune threshold)
SELECT srcaddr, dstaddr, SUM(bytes) AS egress_bytes, COUNT(*) AS flows
FROM flowlogs.vpc_flow
WHERE "flow-direction" = 'egress'
  AND NOT regex_like(dstaddr, '^10\.')
  AND NOT regex_like(dstaddr, '^192\.168\.')
GROUP BY srcaddr, dstaddr
HAVING SUM(bytes) > 100000000
ORDER BY egress_bytes DESC
LIMIT 50;
