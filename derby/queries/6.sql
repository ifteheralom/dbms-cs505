select
	sum(l_extendedprice * l_discount) as revenue
from
	lineitem
where
	l_shipdate >= date('1997-01-01')
	and l_shipdate < CAST({fn TIMESTAMPADD(SQL_TSI_YEAR, 1, CAST('1997-01-01 00:00:00' AS TIMESTAMP))} AS DATE)
	and l_discount between 0.07 - 0.01 and 0.07 + 0.01
	and l_quantity < 47;