create database zepto;   
use zepto; 

-- CREATE TABLE
create table zepto(
sku_id serial primary key,
Category varchar (120),
name varchar (150) not null,
mrp numeric (8,2),
discountPercent numeric (5,2),
availableQuantity integer,
discountedSellingPrice numeric (8,2),
weightInGms integer,
outOfStock varchar (10),
quantity integer);

select*from sqlproject;
 
 -- UNIQUE VALUE
SELECT DISTINCT Category from sqlproject ;
select  count( distinct category) from sqlproject;

--  COUNT PRODUCTS IN EACH CATEGORY
SELECT Category ,count(*) from sqlproject as total_PRODUCTS
GROUP BY Category;

-- EXPENSIVE PRODUCTS
SELECT name,mrp from sqlproject as expensive_products
where mrp>500;

-- OUTOF STOCK PRODUCTS
SELECT name,category, outOfStock from sqlproject
where outOfStock ='TRUE';

-- TOP 10 HIGHEST DISCOUNTED PRODUCT 
SELECT name,mrp ,discountPercent from sqlproject 
order by  discountPercent desc
limit 10;

-- avg product price
SELECT AVG(mrp) as avg_price from sqlproject;

-- CHEAPEST PRODUCTS
SELECT name,mrp ,discountPercent from sqlproject 
order by  discountPercent 
limit 10;

-- PROD BW 1000 TO 3000
select name, discountedSellingPrice from sqlproject
where discountedSellingPrice between 1000 and 3000;

-- PRODUCTS STARTING WITH A 
SELECT name from sqlproject 
where  name like 'a%';

-- BASIC BUSINESS QUESTIONS 
 -- CATEGORY WITH MOST PRODUCTS 
 SELECT Category , count(*) as total_products from sqlproject
 group by Category
 order by total_products desc;
 
-- TOTAL INVENTORY AVAILABLE 
SELECT SUM(availableQuantity) AS TOTAL_INVENTORY
FROM sqlproject;
 
 -- HIGHEST MRP PROJECT 
 SELECT name, mrp from sqlproject order by mrp desc 
 limit 1;
  
  -- PRODUCTS WITH ZERO DISCOUNT
  select name from sqlproject
  where discountPercent = 0;
  
  -- PRODUCTS WITH LOW STOCK
  SELECT name, availableQuantity from sqlproject
  where availableQuantity<5
  order by availableQuantity;
  
  -- INTERMEDIATE SQL QUERRIES
  -- CREATE PRICE SEGMENTS (CASE)
  SELECT name, mrp,
  case
  when mrp>8000 then 'premium'
  when mrp between 5000 and 8000 then'mid_range'
  else'budget'
  end as price_segment
  from sqlproject;
  
  -- CALCULATE DISCOUNT AMOUNT@
  SELECT name ,mrp, discountedSellingPrice ,(mrp - discountedSellingPrice) 
  as discount_amount
  from sqlproject ;
  
  -- AVG DISCOUNT BY CATEGORY
  SELECT Category , avg(discountPercent) AS AVG_DISCOUNT from sqlproject
  group by Category;
  
  -- TOP 5 CATEGORIES BY AVG PRICE
  SELECT Category, avg(discountedSellingPrice) AS AVG_PRICE FROM sqlproject
  group by Category 
  order by Category desc
  limit 5;
  
-- Count Out-of-Stock Products Category Wise@
select Category, outOfStock, COUNT(*) from sqlproject
where outOfStock = 'TRUE'
group by Category; 

-- Find Products Giving More Than 50% Discount
SELECT name, discountPercent as big_discount from sqlproject 
where discountPercent>10;

-- Find Total Potential Revenue
select sum(discountedSellingPrice*availableQuantity) as total_revenue from sqlproject;

-- Find Highest Revenue Generating Products
SELECT name,(discountedSellingPrice * availableQuantity)AS revenue
FROM sqlproject
ORDER BY revenue DESC
LIMIT 10;

-- Average Weight per Category
select Category,avg(weightInGms) as avg_wt from sqlproject 
group by Category;


--- DATA CLEANING
-- FINDING NULL VALUES@
SELECT * from sqlproject 
where mrp is null 
or  discountedSellingPrice is null;

-- FINDING DUPLICATES
SELECT name, count(*) as duplicate_names from sqlproject
group by name
having count(*)>1;

-- Standardize Category Names
update sqlproject
set Category= upper(category);

-- Create Inventory Status
select name,availableQuantity,
case 
when availableQuantity=0 THEN 'OUT_OF_STOCK'
WHEN availableQuantity>3 THEN 'MIN_QTY'
ELSE 'IN_STOCK'
END
FROM SQLPROJECT;

-- Rank Products by Price
select name, mrp ,rank() 
over( order by mrp desc )from sqlproject;

-- Dense Rank on Discounts
select name, discountedSellingPrice, dense_rank() 
over(order by discountedSellingPrice desc) from sqlproject;

-- Top 3 Expensive Products Per Category
 
 -- Compare Product Price with Category Average
 select name,Category, mrp,avg(mrp) 
 over (partition by Category) from sqlproject ;

 -- Running Total Revenue
 select name, discountedSellingPrice ,sum(discountedSellingPrice)
 over (order by discountedSellingPrice desc) from sqlproject;
 
 -- Find Revenue Contribution %
  SELECT name,discountedSellingPrice,ROUND(discountedSellingPrice * 100 /SUM(discountedSellingPrice) 
  OVER(),2) AS revenue_percent from sqlproject;
  

 