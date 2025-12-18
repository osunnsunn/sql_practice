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
	online_sales AS o;

--課題２
SELECT
    c.customer_id,
	c.customer_name
FROM customers c
LEFT JOIN store_sales s
  ON c.customer_id = s.customer_id
WHERE s.customer_id IS NULL;

--課題３
SELECT
    sales_category,
    COUNT(*) AS sales_count
FROM (
    SELECT
        CASE
            WHEN amount >= 10000 THEN '高'
            WHEN amount >= 5000 THEN '中'
            ELSE '小'
        END AS sales_category
    FROM store_sales
    UNION ALL
    SELECT
        CASE
            WHEN amount >= 10000 THEN '高'
            WHEN amount >= 5000 THEN '中'
            ELSE '小'
        END AS sales_category
    FROM online_sales
) AS sales
GROUP BY
    sales_category
ORDER BY
    CASE sales_category
        WHEN '高' THEN 1
        WHEN '中' THEN 2
        WHEN '小' THEN 3
    END;

--課題４
SELECT
    S1.employee_name AS employee_name,
	COALESCE(S2.employee_name,'N/A') AS manager_name
FROM
    employees AS S1
LEFT JOIN employees AS S2
    ON S2.manager_id = S1.employee_id
ORDER BY S1.employee_name;

--課題５
SELECT
    s.*
FROM
    store_sales AS s
JOIN
    employees AS e
	ON s.employee_id = e.employee_id
WHERE
    e.hire_date >= DATE '2022-01-01';

--課題６
WITH product_sales AS (
    SELECT
        product_id,
        SUM(amount) AS total_amount
    FROM (
        SELECT
		    product_id,
			amount
		FROM store_sales
        UNION ALL
        SELECT
		    product_id,
			amount
		FROM online_sales
    ) AS all_sales
    GROUP BY product_id
)
SELECT
    RANK() OVER (
        ORDER BY ps.total_amount DESC
    ) AS sales_rank,
	ps.product_id,
	p.product_name,
	ps.total_amount
FROM product_sales AS ps
JOIN products AS p ON ps.product_id = p.product_id
ORDER BY sales_rank;

--課題７
WITH all_sales AS (
    SELECT
        c.prefecture AS prefecture,
        s.amount AS amount
    FROM store_sales AS s
    JOIN customers AS c
        ON c.customer_id = s.customer_id
    UNION ALL
    SELECT
        c.prefecture AS prefecture,
        o.amount AS amount
    FROM online_sales AS o
    JOIN customers AS c
        ON c.customer_id = o.customer_id
)
SELECT
    prefecture,
    SUM(amount) AS total_sales_amount
FROM all_sales
GROUP BY prefecture;

--課題８
SELECT
    c.customer_name,
	cs.total_amount
FROM (
    SELECT
	    customer_id,
		SUM(amount) AS total_amount
	FROM (
	    SELECT
		    customer_id,
			amount
		FROM store_sales
		UNION ALL
		SELECT
		    customer_id,
			amount
		FROM online_sales
		) AS sales
    GROUP BY customer_id
	) AS cs
JOIN customers AS c
    ON c.customer_id = cs.customer_id
ORDER BY cs.total_amount DESC
LIMIT 1;

--課題９
SELECT
    s.store_name,
    ss.sale_date,
    ss.amount AS day_amount,
    SUM(ss.amount) OVER (
        PARTITION BY ss.store_id
        ORDER BY ss.sale_date
    ) AS total_amount 
FROM store_sales AS ss
JOIN stores AS s
    ON s.store_id = ss.store_id
ORDER BY
    s.store_name,
    ss.sale_date;

--課題１０
SELECT
    c.gender,
	SUM(t.total_amount) AS gender_total_amount
FROM (
    SELECT
	    customer_id,
		SUM(amount) AS total_amount
	FROM (
	    SELECT customer_id,amount FROM store_sales
		UNION ALL
		SELECT customer_id,amount FROM online_sales
		) s
	GROUP BY customer_id
	) t
JOIN customers AS c
    ON c.customer_id = t.customer_id
GROUP BY c.gender
ORDER BY gender_total_amount DESC
LIMIT 1;