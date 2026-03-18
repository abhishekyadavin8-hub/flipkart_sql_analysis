-- Flipkart Product Data Analysis (SQL Project)
-- 1. Database Setup
CREATE DATABASE flipkart;
USE flipkart;

DROP TABLE IF EXISTS flipkart_products;

CREATE TABLE flipkart_products (
    uniq_id CHAR(32) PRIMARY KEY,
    crawl_timestamp DATETIME,
    product_url TEXT,
    product_name VARCHAR(255),
    product_category_tree TEXT,
    pid VARCHAR(50),
    retail_price DECIMAL(10,2),
    discounted_price DECIMAL(10,2),
    image JSON,
    is_FK_Advantage_product BOOLEAN,
    description TEXT,
    product_rating VARCHAR(10),
    overall_rating VARCHAR(10),
    brand VARCHAR(100),
    product_specifications JSON
);

-- 2. SQL Queries
-- Basic Analysis
-- Total Products
SELECT COUNT(*) AS total_products FROM flipkart_products;

-- Unique Brands
SELECT COUNT(DISTINCT brand) AS total_brands 
FROM flipkart_products;

-- Top 10 Brands
SELECT brand, COUNT(*) AS total_products
FROM flipkart_products
GROUP BY brand
ORDER BY total_products DESC
LIMIT 10;

-- Most Expensive Product
SELECT product_name, retail_price
FROM flipkart_products
ORDER BY retail_price DESC
LIMIT 1;

-- Average Price per Category
SELECT product_category_tree, AVG(retail_price) AS avg_price
FROM flipkart_products
GROUP BY product_category_tree;

-- Discount Analysis
-- Products with More Than 50 Percent Discount
SELECT product_name, retail_price, discounted_price
FROM flipkart_products
WHERE discounted_price < retail_price * 0.5;

-- Average Discount Percentage per Brand
SELECT brand,
AVG((retail_price - discounted_price) / retail_price * 100) AS avg_discount
FROM flipkart_products
WHERE retail_price > 0
GROUP BY brand;

-- Category with Highest Average Discount
SELECT product_category_tree,
AVG((retail_price - discounted_price) / retail_price * 100) AS avg_discount
FROM flipkart_products
WHERE retail_price > 0
GROUP BY product_category_tree
ORDER BY avg_discount DESC
LIMIT 1;

-- Ratings Analysis
-- Average Rating per Brand
SELECT brand,
AVG(CAST(product_rating AS DECIMAL(3,2))) AS avg_rating
FROM flipkart_products
WHERE product_rating IS NOT NULL
GROUP BY brand
ORDER BY avg_rating DESC;

-- Brands with Average Rating Greater Than 4.5
SELECT brand,
AVG(CAST(product_rating AS DECIMAL(3,2))) AS avg_rating
FROM flipkart_products
WHERE product_rating IS NOT NULL
GROUP BY brand
HAVING avg_rating > 4.5;

-- Products with No Rating
SELECT COUNT(*) AS no_rating_products
FROM flipkart_products
WHERE product_rating IS NULL;

-- Price Insights
-- Products with No Discount
SELECT product_name, retail_price
FROM flipkart_products
WHERE retail_price = discounted_price
ORDER BY retail_price DESC
LIMIT 10;

-- Products Above 10000
SELECT COUNT(*) AS expensive_products
FROM flipkart_products
WHERE discounted_price > 10000;

-- Advantage vs Non-Advantage Pricing
SELECT is_FK_Advantage_product,
AVG(discounted_price) AS avg_price
FROM flipkart_products
GROUP BY is_FK_Advantage_product;

-- Text and Category Analysis
-- Products Containing Smartphone
SELECT product_name
FROM flipkart_products
WHERE LOWER(product_name) LIKE '%smartphone%';

-- Products per Category
SELECT product_category_tree, COUNT(*) AS total_products
FROM flipkart_products
GROUP BY product_category_tree;

-- Lowest Rated Category
SELECT product_category_tree,
AVG(CAST(overall_rating AS DECIMAL(3,2))) AS avg_rating
FROM flipkart_products
WHERE overall_rating IS NOT NULL
GROUP BY product_category_tree
ORDER BY avg_rating ASC
LIMIT 1;

-- Advanced SQL
-- Rank Brands by Product Count
SELECT brand, COUNT(*) AS total_products,
RANK() OVER (ORDER BY COUNT(*) DESC) AS rank_position
FROM flipkart_products
GROUP BY brand;

-- Price Difference by Brand
SELECT brand,
AVG(retail_price - discounted_price) AS avg_price_difference
FROM flipkart_products
GROUP BY brand
ORDER BY avg_price_difference DESC;
-- Create View for Top Brands
CREATE VIEW top_brands AS
SELECT brand, COUNT(*) AS total_products
FROM flipkart_products
GROUP BY brand;


-- 3. Key Insights 

-- Top brands contribute a significant portion of total products

-- Some categories offer discounts greater than 50 percent

-- High-priced products above 10000 are relatively fewer

-- Ratings vary across brands and categories
