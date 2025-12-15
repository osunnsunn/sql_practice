--課題１
SELECT
    SUM(s.quantity)AS total_quantity,
	SUM(s.amount) AS total_amount
FROM
    store_sales AS s
UNION ALL
SELECT
	SUM(o.quantity) AS total_quantity,
	SUM(o.amount) AS total_amount
FROM
	online_sales AS o

--課題２
SELECT
    c.customer_id,
	c.customer_name
FROM customers c
LEFT JOIN store_sales s
  ON c.customer_id = s.customer_id
WHERE s.customer_id IS NULL;

--課題３