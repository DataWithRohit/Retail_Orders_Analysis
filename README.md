# 🛍️ Retail Orders Analysis  

## 📌 Overview  

This project analyzes **retail orders** to uncover **sales trends, revenue insights, and category performance** across different time periods.  
The analysis focuses on SQL queries to extract **business insights**, along with Python for data cleaning and preparation.  

## 🛠️ Tools & Technologies  

- **SQL (PostgreSQL)**: For querying and data analysis  
- **Python (Jupyter Notebook)**: Data cleaning & preprocessing  
- **Kaggle API**: Dataset extraction  
- **Pandas & NumPy**: Data manipulation  
- **Matplotlib & Seaborn**: Data visualization (if needed in future analysis)  

## 📂 Project Structure  

```
├── Retail_Orders.ipynb      # Data cleaning and preparation in Jupyter Notebook
├── orders.csv               # Dataset used for the analysis
├── SQL_SOLUTIONS.SQL        # SQL queries and solutions
├── SQL_BUSINESS_PROBLEMS    # Business problems addressed
├── README.md                # Project documentation (this file)
```

## 📊 Business Problems Addressed  

1️⃣ **Which products generate the highest revenue?**  
2️⃣ **Which products perform best in each region?**  
3️⃣ **How do monthly sales compare between 2022 and 2023?**  
4️⃣ **Which month has the highest sales for each category?**  
5️⃣ **Which sub-category had the highest profit growth from 2022 to 2023?**  

---  

## 🏆 SQL Queries & Solutions  

### 1️⃣ Find Top 10 Highest Revenue Generating Products  

```sql
SELECT product_id, SUM(sale_price) AS sales
FROM orders
GROUP BY product_id
ORDER BY sales DESC
LIMIT 10;
```

📺 **Insight:** Identifies the best-selling products based on total revenue generated.  

---  

### 2️⃣ Find Top 5 Highest Selling Products in Each Region  

```sql
SELECT region, product_id, sales, RNK
FROM (
  SELECT region, product_id, SUM(sale_price) AS sales,
         RANK() OVER (PARTITION BY region ORDER BY SUM(sale_price) DESC) AS RNK
  FROM orders
  GROUP BY region, product_id
) AS selling_products
WHERE RNK <= 5;
```

📺 **Insight:** Determines the most popular products in different regions to help in inventory distribution.  

---  

### 3️⃣ Month-over-Month Sales Comparison (2022 vs 2023)  

```sql
SELECT
    TO_CHAR(order_date, 'Month') AS month_name,
    DATE_TRUNC('month', order_date) AS month_start,
    SUM(CASE WHEN EXTRACT(YEAR FROM order_date) = 2022 THEN sale_price ELSE 0 END) AS sales_2022,
    SUM(CASE WHEN EXTRACT(YEAR FROM order_date) = 2023 THEN sale_price ELSE 0 END) AS sales_2023
FROM orders
WHERE EXTRACT(YEAR FROM order_date) IN (2022, 2023)
GROUP BY month_start, month_name
ORDER BY month_start;
```

📺 **Insight:** Helps businesses analyze seasonal trends and identify whether sales have increased or declined over the years.  

---  

### 4️⃣ Find the Month with the Highest Sales for Each Category  

```sql
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
```

📺 **Insight:** Helps retailers determine the peak demand month for different categories to adjust stock levels accordingly.  

---  

### 5️⃣ Find the Sub-Category with the Highest Profit Growth (2023 vs 2022)  

```sql
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

📺 **Insight:** Identifies the most profitable growing sub-category, useful for marketing and business strategy.  

---  

## 📊 Key Findings  

✅ **Revenue Drivers:** The highest revenue-generating products can be prioritized in marketing campaigns.  
✅ **Regional Trends:** Understanding region-wise performance helps in optimizing logistics and promotions.  
✅ **Seasonal Impact:** Monthly sales trends show if specific months require more stock.  
✅ **Growth Opportunities:** Identifying sub-categories with high profit growth can lead to better business decisions.  

---  

## 🚀 Future Improvements  

💪 **Advanced Visualizations:** Using Python libraries like **Matplotlib, Seaborn, or Power BI** to visualize trends.  
💪 **Predictive Analysis:** Applying **time series forecasting models** to predict future sales.  
💪 **Customer Segmentation:** Clustering customers based on purchase patterns for targeted marketing.  

---  

## 📢 Connect With Me  

💡 **GitHub:** [DataWithRohit](https://github.com/DataWithRohit/)  
💡 **LinkedIn:** [RohitPanwar22](https://www.linkedin.com/in/rohit-panwar22/)  

---  


