-- Rejected traffic grouped by port (blocked-probe overview)
SELECT dstport, protocol, COUNT(*) AS rejects, COUNT(DISTINCT srcaddr) AS sources
FROM flowlogs.vpc_flow
WHERE action = 'REJECT'
GROUP BY dstport, protocol
ORDER BY rejects DESC
LIMIT 50;
