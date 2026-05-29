--SQL Retail Sales Analysis

CREATE DATABASE RETAIL_SALES_PROJECT;

-- Create TABLE
DROP TABLE IF EXISTS RETAIL_SALES;

CREATE TABLE RETAIL_SALES (
	TRANSACTION_ID INT PRIMARY KEY,
	SALE_DATE DATE,
	SALE_TIME TIME,
	CUSTOMER_ID INT,
	GENDER VARCHAR(15),
	AGE INT,
	CATEGORY VARCHAR(15),
	QUANTITY INT,
	PRICE_PER_UNIT FLOAT,
	COGS FLOAT,
	TOTAL_SALE FLOAT
);


SELECT
	*
FROM
	RETAIL_SALES
LIMIT
	10;

--1. Check Total Records

SELECT
	COUNT(*)
FROM
	RETAIL_SALES;
--Data Cleaning

--2. Check NULL Values

SELECT
	*
FROM
	RETAIL_SALES
WHERE
	TRANSACTION_ID IS NULL
	OR SALE_DATE IS NULL
	OR SALE_TIME IS NULL
	OR CUSTOMER_ID IS NULL
	OR GENDER IS NULL
	OR AGE IS NULL
	OR CATEGORY IS NULL
	OR QUANTITY IS NULL
	OR PRICE_PER_UNIT IS NULL
	OR COGS IS NULL
	OR TOTAL_SALE IS NULL;

-- 3. Remove NULL Records

DELETE FROM RETAIL_SALES
WHERE
	TRANSACTION_ID IS NULL
	OR SALE_DATE IS NULL
	OR SALE_TIME IS NULL
	OR CUSTOMER_ID IS NULL
	OR GENDER IS NULL
	OR AGE IS NULL
	OR CATEGORY IS NULL
	OR QUANTITY IS NULL
	OR PRICE_PER_UNIT IS NULL
	OR COGS IS NULL
	OR TOTAL_SALE IS NULL;

-- 4. Check Duplicate Records

SELECT
	TRANSACTION_ID,
	COUNT(*)
FROM
	RETAIL_SALES
GROUP BY
	TRANSACTION_ID
HAVING
	COUNT(*) > 1;

--Data Exploration

--How many sales we have?

SELECT
	COUNT(*) AS TOTAL_SALES
FROM
	RETAIL_SALES;

--OR
SELECT
	COUNT(TOTAL_SALE) AS TOTAL_SALES
FROM
	RETAIL_SALES;

--How many unique customer we have?

SELECT
	COUNT(DISTINCT CUSTOMER_ID) AS UNIQUE_CUSTOMER
FROM
	RETAIL_SALES;

--How many unique category we have?

SELECT DISTINCT
	CATEGORY
FROM
	RETAIL_SALES;


-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

SELECT
	*
FROM
	RETAIL_SALES
WHERE
	SALE_DATE = '2022-11-05';


-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

SELECT
	TRANSACTION_ID,
	CATEGORY,
	SALE_DATE,
	QUANTITY
FROM
	RETAIL_SALES
WHERE
	CATEGORY = 'Clothing'
	AND TO_CHAR(SALE_DATE, 'YYYY-MM') = '2022-11'
	AND QUANTITY >= 4;


-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT
	CATEGORY,
	SUM(TOTAL_SALE) AS TOTAL_SALES,
	COUNT(*) AS TOTAL_ORDERS
FROM
	RETAIL_SALES
GROUP BY
	1;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT
	ROUND(AVG(AGE), 2) AS AVG_AGE
FROM
	RETAIL_SALES
WHERE
	CATEGORY = 'Beauty';


-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT
	*
FROM
	RETAIL_SALES
WHERE
	TOTAL_SALE >= 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT category , gender ,COUNT(transaction_id) FROM retail_sales
GROUP BY 1,2
ORDER BY 1;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT 
       year,
       month,
    avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1, 2
) as t1
WHERE rank = 1

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT
	CUSTOMER_ID,
	SUM(TOTAL_SALE) AS HIGHEST_SALES_BY_CUSTOMER
FROM
	RETAIL_SALES
GROUP BY
	CUSTOMER_ID
ORDER BY
	SUM(TOTAL_SALE) DESC;

LIMIT
	5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT
	CATEGORY,
	COUNT(DISTINCT CUSTOMER_ID) AS UNIQUE_CUSTOMERS
FROM
	RETAIL_SALES
GROUP BY
	CATEGORY;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift

-- Q11. Classify each product category as High, Medium, or Low Revenue based on its total sales performance.
SELECT
	CATEGORY,
	CASE
		WHEN SUM(TOTAL_SALE) > 50000 THEN 'High Revenue'
		WHEN SUM(TOTAL_SALE) BETWEEN 20000 AND 50000  THEN 'Medium Revenue'
		ELSE 'Low Revenue'
	END AS REVENUE_STATUS
FROM
	RETAIL_SALES
GROUP BY
	CATEGORY;

-- Q12. Which customers are VIP customers?

SELECT
	CUSTOMER_ID,
	SUM(TOTAL_SALE) AS SPENDING
FROM
	RETAIL_SALES
GROUP BY
	CUSTOMER_ID
ORDER BY
	SPENDING DESC
LIMIT
	10;

-- Q13.Which age group spends the most?
SELECT
	CASE
		WHEN AGE < 20 THEN 'Teen'
		WHEN AGE BETWEEN 20 AND 40  THEN 'Adult'
		ELSE 'Senior'
	END AS AGE_GROUP,
	SUM(TOTAL_SALE) AS SPENDING
FROM
	RETAIL_SALES
GROUP BY
	AGE_GROUP
ORDER BY
	SPENDING DESC;

-- Q14.Which day has maximum sales?
SELECT
	SALE_DATE,
	SUM(TOTAL_SALE) AS REVENUE
FROM
	RETAIL_SALES
GROUP BY
	SALE_DATE
ORDER BY
	REVENUE DESC
LIMIT
	1;

--Q15. Repeat Customers

SELECT
	CUSTOMER_ID,
	COUNT(*) AS PURCHASES
FROM
	RETAIL_SALES
GROUP BY
	CUSTOMER_ID
HAVING
	COUNT(*) > 1
ORDER BY
	PURCHASES DESC;

-- End of project
