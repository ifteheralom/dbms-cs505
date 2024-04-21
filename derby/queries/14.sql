select
	100.00 * sum(case
		when p_type like 'PROMO%'
			then l_extendedprice * (1 - l_discount)
		else 0
	end) / sum(l_extendedprice * (1 - l_discount)) as promo_revenue
from
	lineitem,
	part
where
	l_partkey = p_partkey
	and l_shipdate >= date('1993-01-01')
	and l_shipdate < CAST({fn TIMESTAMPADD(SQL_TSI_MONTH, 1, CAST('1993-01-01 00:00:00' AS TIMESTAMP))} AS DATE)