--pizza sale management--


DROP TABLE pizza_sale
CREATE TABLE pizza_sale(
pizza_id SERIAL , 	
order_id INT  ,
pizza_name_id	VARCHAR(50) ,
quantity SMALLINT  ,
order_date VARCHAR (50) ,	
order_time	TIME  ,
unit_price	numeric ,
total_price	numeric ,
pizza_size	VARCHAR(50) ,
pizza_category	VARCHAR(50) ,
pizza_ingredients	VARCHAR(100) ,
pizza_name	VARCHAR(50) 
);
COPY pizza_sale FROM 'C:\SQL Bootcamp\pizza_sales.CSV' with csv HEADER
 SELECT * FROM pizza_sale
 ALTER TABLE pizza_sale
ADD pizza_date TIMESTAMP;
update pizza_sale
SET  pizza_date = TO_TIMESTAMP( order_date ,'DD-MM-YY');
ALTER TABLE pizza_sale DROP COLUMN  order_date
ALTER TABLE pizza_sale RENAME COLUMN pizza_date TO order_date
COMMIT;
SELECT DISTINCT order_date FROM pizza_sale

--Find total revenue--
SELECT SUM(total_price) as Total_revenue FROM pizza_sale
ALTER TABLE pizza_sale
ALTER COLUMN total_price TYPE numeric;
ALTER TABLE pizza_sale
ALTER COLUMN unit_price TYPE numeric;

--Find average order value--
SELECT SUM(total_price)/count(distinct (order_id))AS AOV FROM pizza_sale ;
--Total pizza sold--
SELECT SUM(quantity) AS TPS FROM pizza_sale
--Total orders--
SELECT COUNT(distinct order_id) AS total_order FROM pizza_sale
--Average pizza per order--
SELECT (SUM(quantity)::decimal(10,2)/COUNT(distinct order_id)::decimal(10,2))::decimal(10,2) FROM pizza_sale
---Hourly trend for total pizza sold--
select date_part('hour',order_time) AS order_hour,SUM(quantity) as Total_pizza_sold
from pizza_sale
group by order_hour
order by order_hour
--Weekly Trend for Total Orders--
SELECT
    EXTRACT(YEAR FROM order_date) AS year,
    EXTRACT(week FROM order_date) AS week_number,
    COUNT(DISTINCT order_id)AS total_order
FROM
    pizza_sale
GROUP BY
    year, week_number
ORDER BY
     year, week_number

--Percentage of sales by pizza category

 select pizza_category,sum(total_price)as total_sales, sum (total_price)*100/(select sum(total_price)from pizza_sale) AS percentage_of_total 
 from pizza_sale
 group by pizza_category
 --Percentage of sales by pizza category on first month
 select pizza_category, sum (total_price)*100/(select sum(total_price)from pizza_sale WHERE EXTRACT(MONTH FROM order_date) = 1) from pizza_sale
WHERE EXTRACT(MONTH FROM order_date) = 1
 group by pizza_category
 
 ---Percentage of sales by pizza size

 select pizza_size,sum(total_price)as total_sales ,cast(sum (total_price)*100/(select sum(total_price)from pizza_sale) as decimal(10,2)) AS percentage_of_total 
 from pizza_sale
  extract(quarter, order_date)
 group by pizza_size
 
 --top 5 bestsellers by Revenue,total quantity and total orders
 select pizza_name,sum(total_price) as total_revenue
 from pizza_sale
 group by pizza_name
 order by total_revenue desc
 limit 5
 ;
  select pizza_name,sum(quantity) as total_quantity
 from pizza_sale
 group by pizza_name
 order by total_quantity desc
 limit 5
 ;
  select pizza_name,count(distinct order_id) as total_order
 from pizza_sale
 group by pizza_name
 order by total_order desc
 limit 5
 ;
 
