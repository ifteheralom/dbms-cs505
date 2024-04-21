select
	o_orderpriority,
	count(*) as order_count
from
	orders
where
	o_orderdate >= date('1995-01-01')
	and o_orderdate < CAST({fn TIMESTAMPADD(SQL_TSI_MONTH, 3, CAST('1995-01-01 00:00:00' AS TIMESTAMP))} AS DATE)
	and exists (
		select
			*
		from
			lineitem
		where
			l_orderkey = o_orderkey
			and l_commitdate < l_receiptdate
	)
group by
	o_orderpriority
order by
	o_orderpriority;