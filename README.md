# Retail Orders Analysis

## Overview
This project analyzes retail order data using SQL queries in PostgreSQL. The dataset is obtained via Kaggle API and cleaned using Jupyter Notebook before performing SQL analysis.

## Dataset
The dataset consists of retail order details with attributes like `order_date`, `sale_price`, `product_id`, `category`, `sub_category`, `profit`, and `region`.

## SQL Queries

```sql
-- Q1) Find top 10 highest revenue generating products.
SELECT product_id , SUM(sale_price) AS sales
FROM orders
GROUP BY product_id 
ORDER BY sales DESC
LIMIT 10;

-- Q2) Find top 5 highest selling products in each region.
SELECT region , product_id , sales , RNK
FROM(
  SELECT region , product_id , SUM(sale_price) AS sales,
  RANK() OVER(PARTITION BY region ORDER BY SUM(sale_price) DESC) AS RNK
  FROM orders
  GROUP BY region , product_id 
) AS selling_products 
WHERE RNK <= 5;

-- Q3) Find the month-over-month comparison for 2022 vs 2023 sales.
SELECT 
    TO_CHAR(order_date, 'Month') AS month_name,  -- Convert date to month name
    DATE_TRUNC('month', order_date) AS month_start,  -- Truncate date to first day of the month
    SUM(CASE WHEN EXTRACT(YEAR FROM order_date) = 2022 THEN sale_price ELSE 0 END) AS sales_2022,
    SUM(CASE WHEN EXTRACT(YEAR FROM order_date) = 2023 THEN sale_price ELSE 0 END) AS sales_2023
FROM orders
WHERE EXTRACT(YEAR FROM order_date) IN (2022, 2023)  -- Filter only 2022 and 2023 data
GROUP BY month_start, month_name
ORDER BY month_start;

-- Q4) For each category, find the month with the highest sale.
SELECT category, sales, month_name
FROM (
    SELECT category,
           SUM(sale_price) AS sales, 
            TO_CHAR(order_date, 'Month') AS month_name,
           RANK() OVER (PARTITION BY category ORDER BY SUM(sale_price) DESC) AS rnk
    FROM orders
    GROUP BY category, TO_CHAR(order_date, 'Month')
) AS highest_sale
WHERE rnk = 1;

-- Q5) Which sub-category had the highest growth in profit in 2023 compared to 2022.
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
```

## Tools Used
- **PostgreSQL**: For executing SQL queries.
- **Jupyter Notebook**: For data cleaning and preparation.
- **Kaggle API**: For dataset retrieval.
- **GitHub**: For version control and project hosting.

## Project Structure
- `Retail_Orders.ipynb`: Jupyter Notebook for data cleaning and preparation.
- `SQL_SOLUTIONS.SQL`: Contains all SQL queries used for analysis.
- `SQL_BUSINESS_PROBLEMS`: List of business problems solved using SQL.
- `orders.csv`: The dataset used in this analysis.

## Conclusion
This project provides valuable insights into retail sales, product performance, and profit trends using SQL. It helps businesses make data-driven decisions by analyzing revenue, sales trends, and growth comparisons.
