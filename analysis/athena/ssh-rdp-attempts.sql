-- SSH/RDP brute-force signal
SELECT srcaddr, COUNT(*) AS attempts, COUNT(DISTINCT dstaddr) AS targets
FROM flowlogs.vpc_flow
WHERE action = 'REJECT' AND dstport IN (22, 3389)
GROUP BY srcaddr
HAVING COUNT(*) > 5
ORDER BY attempts DESC;
