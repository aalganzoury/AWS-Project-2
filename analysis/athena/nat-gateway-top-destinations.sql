-- NAT egress: top external destinations (use pkt-srcaddr to see true client)
SELECT "pkt-srcaddr" AS client, dstaddr, SUM(bytes) AS bytes, COUNT(*) AS flows
FROM flowlogs.vpc_flow
WHERE "pkt-srcaddr" <> '' AND NOT regex_like(dstaddr, '^10\.')
GROUP BY "pkt-srcaddr", dstaddr
ORDER BY bytes DESC
LIMIT 50;
