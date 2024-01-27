SELECT * 
FROM wfp_food_prices_pakistan;

SET SQL_SAFE_UPDATES = 0; 

UPDATE wfp_food_prices_pakistan
SET date = str_to_date(date,'%m/%d/%Y');

ALTER TABLE wfp_food_prices_pakistan
MODIFY date DATETIME;

-- Select dates and commodities for cities Quetta, Karachi, and Peshawar where price was less than or equal 50 PKR.

SELECT date , cmname
FROM wfp_food_prices_pakistan
WHERE price <= 50  AND (mktname IN ('Quetta' , 'Karachi' , 'Peshawar'));

-- Query to check number of observations against each market/city in PK.

SELECT mktname, count(*)
FROM wfp_food_prices_pakistan
GROUP BY mktname;

-- Show number of distinct cities.

SELECT count(distinct mktname) as 'no. of cities'
FROM wfp_food_prices_pakistan;

-- List down/show the names of cities in the table.

SELECT distinct mktname
FROM wfp_food_prices_pakistan;

-- List down/show the names of commodities in the table.

SELECT distinct cmname
FROM wfp_food_prices_pakistan;

-- List Average Prices for Wheat flour - Retail in EACH city separately over the entire period.

SELECT mktname , avg(price) as 'average prices for wheat flour-Retail'
FROM wfp_food_prices_pakistan
WHERE cmname = 'Wheat flour - Retail'
GROUP BY mktname;

-- Calculate summary stats (avg price, max price) for each city separately for all cities except Karachi and sort alphabetically the city names, commodity names where commodity is Wheat (does not matter which one) with separate rows for each commodity.

SELECT mktname , cmname , avg(price) as 'average price' , max(price) as 'maximum price'
FROM wfp_food_prices_pakistan
WHERE mktname not in ('Karachi') AND cmname in ('Wheat flour - Retail','Wheat - Retail')
GROUP BY mktname , cmname
ORDER BY mktname asc , cmname asc;

-- Calculate Avg_prices for each city for Wheat Retail and show only those avg_prices which are less than 30.

SELECT mktname , avg(price) as 'average price for wheat retail' , cmname
FROM wfp_food_prices_pakistan
GROUP BY mktname , cmname
HAVING cmname = ('Wheat - Retail') AND (avg(price) < 30);

-- Prepare a table where you categorize prices based on a logic (price < 30 is LOW, price > 250 is HIGH, in between are FAIR).

SELECT * , 
CASE
    WHEN price < 30 THEN 'Low'
    WHEN 30 <= price and price <= 250 THEN 'Fair'
    WHEN price > 250 THEN 'High'
END as 'price range'
FROM wfp_food_prices_pakistan;

-- Create a query showing date, cmname, category, city, price, city_category where Logic for city category is: Karachi and Lahore are 'Big City', Multan and Peshawar are 'Medium-sized city', Quetta is 'Small City'.

SELECT date , cmname , category , mktname , price ,
CASE
    WHEN mktname IN ('Karachi' , 'Lahore') THEN 'Big City'
    WHEN mktname IN ('Multan' , 'Peshawar') THEN 'Medium Sized City'
    WHEN mktname IN('Quetta') THEN 'Small City'
END as city_category
FROM wfp_food_prices_pakistan;

-- Create a query to show date, cmname, city, price. Create new column price_fairness through CASE showing price is fair if less than 100, unfair if more than or equal to 100, if > 300 then 'Speculative'.

SELECT date , cmname , mktname , price ,
CASE
    WHEN price < 100 THEN 'price is fair'
    WHEN 300 >= price >= 100 THEN 'price is unfair'          
    WHEN price > 300 THEN 'Speculative'
END as price_fairness
FROM wfp_food_prices_pakistan;

-- Join the food prices and commodities table with a left join.

SELECT *
FROM wfp_food_prices_pakistan
LEFT JOIN commodity ON wfp_food_prices_pakistan.cmname = commodity.cmname;

-- Join the food prices and commodities table with an inner join.

SELECT *
FROM wfp_food_prices_pakistan
INNER JOIN commodity ON wfp_food_prices_pakistan.cmname = commodity.cmname;