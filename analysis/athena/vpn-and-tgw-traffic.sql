-- Hybrid path verification: on-prem <-> VPC via TGW/VPN
SELECT srcaddr, dstaddr, "traffic-path" AS path, action, COUNT(*) AS flows, SUM(bytes) AS bytes
FROM flowlogs.vpc_flow
WHERE (regex_like(srcaddr, '^192\.168\.') OR regex_like(dstaddr, '^192\.168\.'))
GROUP BY srcaddr, dstaddr, "traffic-path", action
ORDER BY bytes DESC
LIMIT 100;
