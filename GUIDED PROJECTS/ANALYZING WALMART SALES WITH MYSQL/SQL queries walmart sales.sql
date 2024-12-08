--- FIRST_GUIDED_PROJECT_2024
Create database PORTFOLIO_PROJECT_MYSQL;

--- creating a table to input data and data wranggling to ensure all data is clean
Create table if not exists walmart_sales( 
       invoice_id VARCHAR (30) NOT NULL PRIMARY KEY,
       branch VARCHAR (5) NOT NULL,
       city VARCHAR (30) NOT NULL,
       customer_type VARCHAR (30) NOT NULL,
       gender VARCHAR (10) NOT NULL,
       product_line VARCHAR (100) NOT NULL,
       unit_price DECIMAL (10,2) NOT NULL,
       quantity INT NOT NULL,
       VAT FLOAT (6,4) NOT NULL,
       total DECIMAL (12,4) NOT NULL,
       date DATETIME NOT NULL,
       time TIME NOT NULL,
       payment_method VARCHAR (15) NOT NULL,
       cogs DECIMAL (10,2) NOT NULL,
       gross_margin_percentage FLOAT (11,9) NOT NULL,
       gross_income DECIMAL (12,4) NOT NULL,
       rating FLOAT (2,1) NOT NULL
       );
       
--- importing data from CSV files 
SELECT * 
FROM portfolio_project_mysql.walmart_sales;
       
--- FEATURE ENGINEERING ---
       
--- time_of_day
ALTER TABLE walmart_sales 
ADD COLUMN time_of_day VARCHAR(20) NOT NULL;

UPDATE walmart_sales
SET time_of_day = (CASE 
              WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
              WHEN time BETWEEN '12:00:01' AND '16:00:00' THEN 'Afternoon'
              ELSE 'Evening'
         END);
         
--- day_name
ALTER TABLE walmart_sales
ADD COLUMN day_name VARCHAR(10) NOT NULL;

UPDATE walmart_sales
SET day_name = DAYNAME(date);

--- month_name
ALTER TABLE walmart_sales
ADD COLUMN month_name VARCHAR(10) NOT NULL;

UPDATE walmart_sales
SET month_name = MONTHNAME(date);

--- GENERIC QUESTIONS ---

--- unique cities in the data
SELECT DISTINCT city 
FROM walmart_sales;

--- unique branches
SELECT DISTINCT branch
FROM walmart_sales;

--- which branch is in which city
SELECT DISTINCT branch, city
FROM walmart_sales;

--- PRODUCTS ---

--- unique product lines is in the data
SELECT COUNT(DISTINCT product_line) AS different_product_lines
FROM walmart_sales;

--- most common payment method
SELECT payment_method,
   COUNT(payment_method) AS payment_method_count
FROM walmart_sales
GROUP BY payment_method
ORDER BY payment_method_count DESC
LIMIT 1;

--- most selling product line
SELECT product_line,
   COUNT(product_line) AS highest_product
FROM walmart_sales
GROUP BY product_line
ORDER BY highest_product DESC
LIMIT 1;

--- total revenue by month
SELECT month_name,
   SUM(total) AS monthly_sales
FROM walmart_sales
GROUP BY month_name
ORDER BY monthly_sales DESC;

--- month with largest COGS
SELECT month_name,
    SUM(cogs) AS cogs_mtd
FROM walmart_sales
GROUP BY month_name
ORDER BY cogs_mtd DESC;

--- product_line with largest revenue 
SELECT product_line,
	SUM(total) AS product_revenue
FROM walmart_sales
GROUP BY product_line
ORDER BY product_revenue DESC
LIMIT 1;

--- city with the biggest revenue
SELECT city, 
     SUM(total) AS total_sales_per_city
FROM walmart_sales
GROUP BY city
ORDER BY total_sales_per_city DESC
LIMIT 1;

--- product line with the largest VAT 
SELECT product_line, 
     SUM(VAT) AS product_VAT
FROM walmart_sales
GROUP BY product_line
ORDER BY product_VAT DESC
LIMIT 1;

--- add column to indicate good or bad in product lines. Good if greater than avg_sales
ALTER TABLE walmart_sales
ADD COLUMN remarks VARCHAR(10);

SELECT AVG(total) INTO @avg_sales
FROM walmart_sales;

SET SQL_SAFE_UPDATES = 0;

UPDATE walmart_sales
SET remarks = 'Good'
WHERE total > @avg_sales;

UPDATE walmart_sales
SET remarks = 'Bad'
WHERE total <= @avg_sales;

SELECT
    product_line,
    ROUND(AVG(total), 2) AS avg_sales,
    CASE
        WHEN AVG(total) > (SELECT AVG(total) FROM walmart_sales) THEN 'Good'
        ELSE 'Bad'
    END AS remarks
FROM walmart_sales
GROUP BY product_line;

--- branch that sold more products than average products sold
SELECT branch, 
       SUM(quantity) AS total_products_sold
FROM walmart_sales
GROUP BY branch
HAVING SUM(quantity) > (
    SELECT AVG(quantity) 
    FROM walmart_sales
);

--- most common product line by gender
SELECT gender,
       product_line,
	COUNT(gender) AS products
FROM walmart_sales
GROUP BY gender, product_line
ORDER BY products DESC;

--- average rating of each product line
SELECT
    product_line,
    ROUND(AVG(rating), 2) AS avg_rating
FROM walmart_sales
GROUP BY product_line
ORDER BY avg_rating DESC;





























