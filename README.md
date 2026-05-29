# Retail Sales Analysis SQL Project

## Table of Contents

- [Project Overview](#project-overview)
- [Objectives](#objectives)
- [Project Structure](#project-structure)
  - [1. Database Setup](#1-database-setup)
  - [2. Data Exploration & Cleaning](#2-data-exploration--cleaning)
  - [3. Data Analysis & Findings](#3-data-analysis--findings)
- [Findings](#findings)
- [Reports](#reports)
- [Conclusion](#conclusion)
- [How to Use](#how-to-use)
- [Project Links](#project-links)
- [Author](#author)

---

## Project Overview
<details>
<summary>Expand</summary>

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: RETAIL_SALES_PROJECT

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

</details>

## Objectives
<details>
<summary>Expand</summary>

- Set up a retail sales database: Create and populate a retail sales database with the provided sales data.  
- Data Cleaning: Identify and remove any records with missing or null values.  
- Exploratory Data Analysis (EDA): Perform basic exploratory data analysis to understand the dataset.  
- Business Analysis: Use SQL to answer specific business questions and derive insights from the sales data.

</details>

## Project Structure
<details>
<summary>Expand</summary>

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `RETAIL_SALES_PROJECT`.
- **Table Creation**: Table `retail_sales` with columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE RETAIL_SALES_PROJECT;

CREATE TABLE retail_sales (
    transactions_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);
```

### 2. Data Exploration & Cleaning

- **Record Count**:  
  ```sql
  SELECT COUNT(*) FROM retail_sales;
  ```
- **Customer Count**:  
  ```sql
  SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
  ```
- **Category Count**:  
  ```sql
  SELECT DISTINCT category FROM retail_sales;
  ```
- **Null Value Check & Removal**:
  ```sql
  SELECT * FROM retail_sales
  WHERE sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL
     OR gender IS NULL OR age IS NULL OR category IS NULL
     OR quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

  DELETE FROM retail_sales
  WHERE sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL
     OR gender IS NULL OR age IS NULL OR category IS NULL
     OR quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
  ```

### 3. Data Analysis & Findings

**Sample Business Queries:**

- All columns for sales made on '2022-11-05':
  ```sql
  SELECT * FROM retail_sales WHERE sale_date = '2022-11-05';
  ```
- Clothing transactions quantity >4, Nov 2022:
  ```sql
  SELECT *
  FROM retail_sales
  WHERE category = 'Clothing'
    AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND quantity >= 4;
  ```
- Total sales per category:
  ```sql
  SELECT category, SUM(total_sale) as net_sale, COUNT(*) as total_orders
  FROM retail_sales
  GROUP BY 1;
  ```
- Average age of customers for 'Beauty' category:
  ```sql
  SELECT ROUND(AVG(age), 2) as avg_age FROM retail_sales WHERE category = 'Beauty';
  ```
- Transactions with total_sale > 1000:
  ```sql
  SELECT * FROM retail_sales WHERE total_sale > 1000;
  ```
- Transactions by gender for each category:
  ```sql
  SELECT category, gender, COUNT(*) as total_trans
  FROM retail_sales
  GROUP BY category, gender
  ORDER BY 1;
  ```
- Average sale per month, best selling month each year:
  ```sql
  SELECT year, month, avg_sale
  FROM (
    SELECT EXTRACT(YEAR FROM sale_date) as year,
           EXTRACT(MONTH FROM sale_date) as month,
           AVG(total_sale) as avg_sale,
           RANK() OVER (PARTITION BY EXTRACT(YEAR FROM sale_date)
           ORDER BY AVG(total_sale) DESC) as rank
    FROM retail_sales
    GROUP BY 1, 2
  ) as t1
  WHERE rank = 1;
  ```
- Top 5 customers by highest total sales:
  ```sql
  SELECT customer_id, SUM(total_sale) as total_sales
  FROM retail_sales
  GROUP BY 1
  ORDER BY 2 DESC
  LIMIT 5;
  ```
- Unique customers per category:
  ```sql
  SELECT category, COUNT(DISTINCT customer_id) as cnt_unique_cs
  FROM retail_sales
  GROUP BY category;
  ```
- Orders by shift (time of day):
  ```sql
  WITH hourly_sale AS (
    SELECT *,
      CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
      END as shift
    FROM retail_sales
  )
  SELECT shift, COUNT(*) as total_orders
  FROM hourly_sale
  GROUP BY shift;
  ```

- Classify revenue per category:
  ```sql
  SELECT CATEGORY,
         CASE
           WHEN SUM(TOTAL_SALE) > 50000 THEN 'High Revenue'
           WHEN SUM(TOTAL_SALE) BETWEEN 20000 AND 50000 THEN 'Medium Revenue'
           ELSE 'Low Revenue'
         END AS REVENUE_STATUS
  FROM RETAIL_SALES
  GROUP BY CATEGORY;
  ```

- Top 10 VIP customers:
  ```sql
  SELECT CUSTOMER_ID, SUM(TOTAL_SALE) AS SPENDING
  FROM RETAIL_SALES
  GROUP BY CUSTOMER_ID
  ORDER BY SPENDING DESC
  LIMIT 10;
  ```

- Highest spending age group:
  ```sql
  SELECT
    CASE
      WHEN AGE < 20 THEN 'Teen'
      WHEN AGE BETWEEN 20 AND 40 THEN 'Adult'
      ELSE 'Senior'
    END AS AGE_GROUP,
    SUM(TOTAL_SALE) AS SPENDING
  FROM RETAIL_SALES
  GROUP BY AGE_GROUP
  ORDER BY SPENDING DESC;
  ```

- Day with maximum sales:
  ```sql
  SELECT SALE_DATE, SUM(TOTAL_SALE) AS REVENUE
  FROM RETAIL_SALES
  GROUP BY SALE_DATE
  ORDER BY REVENUE DESC
  LIMIT 1;
  ```

- Repeat customers (more than one purchase):
  ```sql
  SELECT CUSTOMER_ID, COUNT(*) AS PURCHASES
  FROM RETAIL_SALES
  GROUP BY CUSTOMER_ID
  HAVING COUNT(*) > 1
  ORDER BY PURCHASES DESC;
  ```

</details>

## Findings
<details>
<summary>Expand</summary>

- **Customer Demographics:** The dataset includes customers from various age groups, with sales distributed across different categories.
- **High-Value Transactions:** Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends:** Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights:** The analysis identifies the top-spending customers and the most popular product categories.

</details>

## Reports
<details>
<summary>Expand</summary>

- **Sales Summary:** A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis:** Insights into sales trends across different months and shifts.
- **Customer Insights:** Reports on top customers and unique customer counts per category.

</details>

## Conclusion
<details>
<summary>Expand</summary>

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.

</details>

## How to Use
<details>
<summary>Expand</summary>

- **Clone the Repository**: Clone this project repository from GitHub.
- **Set Up the Database**: Run the SQL scripts provided in the `database_setup.sql` file to create and populate the database.
- **Run the Queries**: Use the SQL queries provided in the `analysis_queries.sql` file to perform your analysis.
- **Explore and Modify**: Feel free to modify the queries to explore different aspects of the dataset or answer additional business questions.

</details>

## Project Links
<details>
<summary>Expand</summary>

- [GitHub Repository](https://github.com/vidhandarji2005-ux/Retial_Sales_SQL_Project)
- [LinkedIn Profile](https://www.linkedin.com/in/vidhan-darji-041a95408)

</details>

## Author

**Vidhan Darji**  
Aspiring Data Analyst & Developer  
Learning SQL, Excel, Power BI, Python (Numpy, Panda) & Data Analytics   
📧 Email: Vidhandarji2005@gmail.com  
📞 Contact No: 6352243436
