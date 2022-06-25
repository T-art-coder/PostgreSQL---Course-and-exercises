-- FUNCTIONS IN POSTGRESQL

-- no difference between functions and procedures in Postgre
-- SQL-functions, Procedure-functions, server functions with C language
-- C functions

-- Syntaxis


-- 1 function

SELECT *
INTO tmp_customers
FROM CUSTOMERS


-- userfriendly function

CREATE OR REPLACE FUNCTION fix_customer_region() RETURNS void as $$
	UPDATE tmp_customers
	SET region = 'unknown'
	WHERE region IS NULL
	$$ language SQL;
	
SELECT fix_customer_region();
	


CREATE OR REPLACE FUNCTION get_total_number_of_goods() RETURNS bigint as $$
	SELECT SUM(units_in_stock)  AS total_goods
	FROM PRODUCTS
$$ LANGUAGE SQL



CREATE OR REPLACE FUNCTION get_avg_price() RETURNS float8 as $$
	SELECT AVG(units_in_stock) 
	FROM PRODUCTS
$$ LANGUAGE SQL

SELECT get_avg_price()


-- FUNCTIONS WITH ARGUMENTS

-- IN/OUT ARGUMENTS
-- INOUT - BETTER NOT TO USE THEM
-- VARIADIC - ARRAY OF INPUT ARGUMENTS
-- DEFAULT VALUE


CREATE OR REPLACE FUNCTION get_product_price_by_name(prod_name varchar) RETURNS real AS  $$
	SELECT unit_price
	FROM products
	WHERE PRODUCT_NAME = PROD_NAME
$$ LANGUAGE SQL;

SELECT get_product_price_by_name('Chocolade') as price

SELECT *
FROM PRODUCTS

CREATE OR REPLACE FUNCTION get_price_boundaries(OUT max_price real,  out min_price real) AS  $$
	SELECT MAX(unit_price), min(unit_price)
	FROM products
$$ LANGUAGE SQL;

SELECT get_price_boundaries()
--

CREATE OR REPLACE FUNCTION get_price_boundaries_by_discontinuity(IN is_discontinued int DEFAULT 1, OUT max_price real,  out min_price real) AS  $$
	SELECT MAX(unit_price), min(unit_price)
	FROM products
	WHERE discontinued = is_discontinued
$$ LANGUAGE SQL;

SELECT get_price_boundaries_by_discontinuity(1)
SELECT * from get_price_boundaries_by_discontinuity(1)


-- RETURNS SETOF datatype_
-- RETURNS SETOF table
-- RETURNS SETOF RECORD ПОЗВОЛЯЕТ ВЫВОДИТЬ СТОЛБЦЫ А НЕ СТРОКУ-ЗАПИСЬ
-- RETURNS TABLE(columnname datatype, )

CREATE OR REPLACE FUNCTION get_average_prices_by_prod_categories()
		RETURNS SETOF double precision as $$
		SELECT AVG(unit_price)
		FROM products
		GROUP BY category_id
$$ LANGUAGE SQL;

SELECT * FROM get_average_prices_by_prod_categories() AS average;

	
	
CREATE OR REPLACE FUNCTION get_avg_prices_by_prod_cats(OUT sum_price real, OUT avg_price float8)
RETURNS SETOF RECORD AS $$
SELECT SUM(unit_price), AVG(unit_price)
	FROM products
	GROUP BY category_id
$$ LANGUAGE SQL;

SELECT sum_price, avg_price FROM get_avg_prices_by_prod_cats()
	
	-- SET OF RECORD -   ПОЗВОЛЯЕТ ВЫВОДИТЬ СТОЛБЦЫ А НЕ СТРОКУ-ЗАПИСЬ
	

CREATE OR REPLACE FUNCTION getcustomersbycountry(customer_country varchar)
	RETURNS TABLE (char_code char, company_name varchar) AS $$
	
	SELECT customer_id, company_name
	FROM customers
	WHERE country = customer_country
	$$ LANGUAGE SQL;
	
SELECT company_name FROM getcustomersbycountry('USA') 
		-- * _ >= =< () {} ^ : $$
	
	
	
DROP FUNCTION getcustomersbycountry;

CREATE OR REPLACE FUNCTION getcustomersbycountry(customer_country varchar)
	RETURNS setof customers as $$
	
	SELECT *
	FROM customers
	WHERE country = customer_country
	$$ LANGUAGE SQL;	
-- we can select all columns or part of them
	
SELECT company_name FROM getcustomersbycountry('USA') 	
	
	
	
	
	
	