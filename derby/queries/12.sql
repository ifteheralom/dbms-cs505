select
	l_shipmode,
	sum(case
		when o_orderpriority = '1-URGENT'
			or o_orderpriority = '2-HIGH'
			then 1
		else 0
	end) as high_line_count,
	sum(case
		when o_orderpriority <> '1-URGENT'
			and o_orderpriority <> '2-HIGH'
			then 1
		else 0
	end) as low_line_count
from
	orders,
	lineitem
where
	o_orderkey = l_orderkey
	and l_shipmode in ('MAIL', 'TRUCK')
	and l_commitdate < l_receiptdate
	and l_shipdate < l_commitdate
	and l_receiptdate >= date('1993-01-01')
	and l_receiptdate < CAST({fn TIMESTAMPADD(SQL_TSI_YEAR, 1, CAST('1993-01-01 00:00:00' AS TIMESTAMP))} AS DATE)
group by
	l_shipmode
order by
	l_shipmode;