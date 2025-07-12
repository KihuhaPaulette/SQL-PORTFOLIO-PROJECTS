--- second SQL project 2025
CREATE TABLE retail_sales (
      transactions_id INT PRIMARY KEY,
	  sale_date DATE,
      sale_time TIME,
      customer_id INT,
      gender VARCHAR (15),
      age INT NULL,
      category VARCHAR (15),
      quantity INT,
      price_per_unit FLOAT NULL,
      cogs FLOAT NULL,
      total_sale FLOAT
);

--- confirming all data is imported
SELECT * 
FROM retail_sales;

--- data cleaning
SELECT * 
FROM retail_sales
WHERE 
transactions_id IS NULL
OR 
sale_date IS NULL
OR 
sale_time IS NULL
OR 
customer_id IS NULL
OR 
gender IS NULL
OR 
age IS NULL
OR 
category IS NULL 
OR 
quantity IS NULL
OR 
price_per_unit IS NULL
OR 
cogs IS NULL
OR 
total_sale IS NULL
;

SET SQL_SAFE_UPDATES = 0;
DELETE FROM retail_sales
WHERE transactions_id IS NULL
OR 
sale_date IS NULL
OR 
sale_time IS NULL
OR 
customer_id IS NULL
OR 
gender IS NULL
OR 
age IS NULL
OR 
category IS NULL 
OR 
quantity IS NULL
OR 
price_per_unit IS NULL
OR 
cogs IS NULL
OR 
total_sale IS NULL;
SET SQL_SAFE_UPDATES = 1;

--- Solving business problems 
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022
SELECT *
FROM retail_sales
WHERE category = 'clothing' AND quantity > 3 AND sale_date BETWEEN '2022-11-1' AND '2022-11-30';

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category
SELECT category,
SUM(total_sale) AS price_per_category
FROM retail_sales
GROUP BY category 
ORDER BY price_per_category DESC;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category
SELECT category,
ROUND(avg(age), 1) AS average_age
FROM retail_sales
WHERE category = 'Beauty'
GROUP BY category
ORDER BY average_age DESC;

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000
SELECT transactions_id, total_sale
FROM retail_sales
WHERE total_sale > 1000
ORDER BY total_sale; 

SELECT COUNT(transactions_id) AS total_valid_transactions   -- calculating total transactions above 1000
FROM retail_sales
WHERE total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category
SELECT category, gender,
    COUNT(transactions_id) AS total_transactions_per_gender
FROM retail_sales
GROUP BY category, gender
ORDER BY total_transactions_per_gender;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT sale_year, sale_month, average_sale
FROM (
    SELECT 
        YEAR(sale_date) AS sale_year,
        MONTH(sale_date) AS sale_month,
        ROUND(AVG(total_sale), 2) AS average_sale,
        RANK() OVER (PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS month_rank
    FROM retail_sales
    GROUP BY YEAR(sale_date), MONTH(sale_date)
) AS ranked_months
WHERE month_rank = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT customer_id, 
SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales
LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category
SELECT category,
count(distinct(customer_id)) AS unique_customers
FROM retail_sales
GROUP BY category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
ALTER TABLE retail_sales
ADD COLUMN time_of_day VARCHAR(20);

SET SQL_SAFE_UPDATES = 0;
UPDATE retail_sales
SET time_of_day = (CASE 
              WHEN sale_time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
              WHEN sale_time BETWEEN '12:00:01' AND '17:00:00' THEN 'Afternoon'
              ELSE 'Evening'
         END);
SET SQL_SAFE_UPDATES = 1;

SELECT time_of_day,
    COUNT(quantity) AS number_of_orders
FROM retail_sales
GROUP BY time_of_day
ORDER BY number_of_orders DESC;











