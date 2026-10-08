-- Port scan: many distinct dst ports from one source in a 5-min window
SELECT srcaddr, date_trunc('minute', from_unixtime("start" - ("start" % 300))) AS window_5min,
  COUNT(DISTINCT dstport) AS distinct_ports, COUNT(*) AS flows
FROM flowlogs.vpc_flow
GROUP BY srcaddr, date_trunc('minute', from_unixtime("start" - ("start" % 300)))
HAVING COUNT(DISTINCT dstport) > 20
ORDER BY distinct_ports DESC;
