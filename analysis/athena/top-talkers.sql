-- Top talkers by bytes (exfil / heavy-hitter review)
SELECT srcaddr, dstaddr, SUM(bytes) AS total_bytes, COUNT(*) AS flows
FROM flowlogs.vpc_flow
WHERE day >= date_format(current_date - INTERVAL '7' DAY, '%Y/%m/%d')
GROUP BY srcaddr, dstaddr
ORDER BY total_bytes DESC
LIMIT 50;
