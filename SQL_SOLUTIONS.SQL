select * from Orders;

--- Q1) find top 10 highest revenue generating products.

select product_id , sum(sale_price) as sales
from orders
group by product_id 
order by sales desc
limit 10 ;

--- Q2) Find top 5 highest selling products in each region.
select region , product_id , sales , RNK
from(
  select region , product_id , sum(sale_price) as sales,
  rank()over(partition by region order by sum(sale_price) desc) as RNK
  from orders
 GROUP by region , product_id 
) as selling_products 
where RNK <= 5;

--- Q3) Find the over month comparison for 2022 and 2023 sales eg. Jan 2022 vs jan 2023.

SELECT 
    TO_CHAR(order_date, 'Month') AS month_name,  -- Convert date to month name
    DATE_TRUNC('month', order_date) AS month_start,  -- Truncate date to first day of the month
    SUM(CASE WHEN EXTRACT(YEAR FROM order_date) = 2022 THEN sale_price ELSE 0 END) AS sales_2022,
    SUM(CASE WHEN EXTRACT(YEAR FROM order_date) = 2023 THEN sale_price ELSE 0 END) AS sales_2023
FROM orders
WHERE EXTRACT(YEAR FROM order_date) IN (2022, 2023)  -- Filter only 2022 and 2023 data
GROUP BY month_start, month_name
ORDER BY month_start;

--- Q4) For each category which month has the highest sale.

SELECT category, sales, month_name
FROM (
    SELECT category,
           SUM(sale_price) AS sales, 
            TO_CHAR(order_date, 'Month') AS month_name,
           RANK() OVER (PARTITION BY category ORDER BY SUM(sale_price) DESC) AS rnk
    FROM orders
    GROUP BY category,   TO_CHAR(order_date, 'Month')
) AS highest_sale
WHERE rnk = 1;

--- Q5) Which sub category had the higest growth by profit in 2023 compare to 2022.

SELECT 
    sub_category,
    SUM(CASE WHEN EXTRACT(YEAR FROM order_date) = 2022 THEN profit ELSE 0 END) AS profit_2022,
    SUM(CASE WHEN EXTRACT(YEAR FROM order_date) = 2023 THEN profit ELSE 0 END) AS profit_2023,
	
    ((SUM(CASE WHEN EXTRACT(YEAR FROM order_date) = 2023 THEN profit ELSE 0 END) - 
      SUM(CASE WHEN EXTRACT(YEAR FROM order_date) = 2022 THEN profit ELSE 0 END)) / 
      NULLIF(SUM(CASE WHEN EXTRACT(YEAR FROM order_date) = 2022 THEN profit ELSE 0 END), 0)) * 100 AS profit_growth_percentage
FROM orders
WHERE EXTRACT(YEAR FROM order_date) IN (2022, 2023)
GROUP BY sub_category
ORDER BY profit_growth_percentage DESC
LIMIT 1;

