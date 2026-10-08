-- Traffic to unusual ports (not web/db/dns/ntp)
SELECT srcaddr, dstaddr, dstport, action, COUNT(*) AS flows, SUM(bytes) AS bytes
FROM flowlogs.vpc_flow
WHERE dstport NOT IN (80, 443, 8080, 3306, 5432, 53, 123)
GROUP BY srcaddr, dstaddr, dstport, action
ORDER BY flows DESC
LIMIT 100;
