SELECT product_name, unit_price, units_in_stock,
	CASE WHEN units_in_stock >= 100 THEN 'LOTS OF'
		 WHEN units_in_stock >= 50 AND units_in_stock < 100 THEN 'AVERAGE'
		 WHEN units_in_stock < 50 THEN 'LOW NUMBER'
		 ELSE 'UNKNOWN'
	END AS amount
FROM products
ORDER BY units_in_stock;

SELECT order_id, order_date,
	CASE WHEN date_part('month', order_date) BETWEEN 3 AND 5 THEN 'SPRING'
		 WHEN date_part('month', order_date) BETWEEN 6 AND 8 THEN 'SUMMER'
		 WHEN date_part('month', order_date) BETWEEN 9 AND 11 THEN 'AUTUMN'
		 ELSE 'WINTER'
	END AS season
FROM ORDERS

SELECT product_name, unit_price,
	CASE WHEN unit_price >=30 THEN 'EXPENSIVE'
	WHEN unit_price <30 THEN 'INEXPENSIVE'
	ELSE 'UNDETERMINED'
	END AS pricedescription
FROM PRODUCTS

-- COALESCE + NULLIF
-- COALESCE - RETURNS FIRST NOT NULL AND SUBSTITUTEES INPUT VALUE
-- NULLIF - COMPARES 2 ARGS. IF THEY ARE EQUAL, RETURNS NULL. ELSE - ARG 1. 

-- COALESCE NULLIF PRACTICE

SELECT *
FROM ORDERS
LIMIT 10;

-- LET'S SUBSTITUTE SOME 'UNKNOWN' FOR NULLS

SELECT order_id, order_date, COALESCE(ship_region, 'unknown') AS ship_region
FROM orders
LIMIT 10

SELECT last_name, first_name, COALESCE(region, 'unknown') as region
FROM employees

SELECT *
FROM CUSTOMERS


-- substitute empty row for null and unknown
SELECT contact_name, COALESCE(NULLIF(city, ''), 'Unknown') AS city
FROM CUSTOMERS


CREATE TABLE budgets
(
	dept serial,
	current_year decimal NULL,
	previous_year decimal NULL
);

INSERT INTO budgets(current_year, previous_year) VALUES(100000, 150000);
INSERT INTO budgets(current_year, previous_year) VALUES(NULL, 300000);
INSERT INTO budgets(current_year, previous_year) VALUES(0, 100000);
INSERT INTO budgets(current_year, previous_year) VALUES(NULL, 150000);
INSERT INTO budgets(current_year, previous_year) VALUES(300000, 250000);
INSERT INTO budgets(current_year, previous_year) VALUES(170000, 170000);
INSERT INTO budgets(current_year, previous_year) VALUES(150000, NULL);

SELECT dept, 
COALESCE(TO_CHAR(NULLIF(current_year, previous_year), 'FM99999999'), 'Same as last year') as budget
FROM budgets
WHERE current_year IS NOT NULL


-- exercises


INSERT INTO customers(customer_id, contact_name, city, country, company_name)
VALUES
('AAAAAB', 'John Mann', 'abc', 'USA', 'fake_company'),
('BBBBBV', 'John Mann', 'acd', 'Austria', 'fake_company');


SELECT contact_name, city, country
FROM customers
ORDER BY contact_name, (
	CASE WHEN city is NULL THEN country
		 ELSE city
	END);

SELECT product_name, unit_price, 
	CASE WHEN unit_price >= 100 THEN 'expensive'
		 WHEN unit_price >= 50 AND units_in_stock < 100 THEN 'average'
		 ELSE 'low price'
	END AS price
FROM products
ORDER BY unit_price desc ;

SELECT contact_name, COALESCE(order_id::text, 'no orders')
FROM customers
LEFT JOIN orders USING(customer_id)
WHERE order_id IS NULL
* _ >= =< () {} ^ :


SELECT CONCAT(last_name, ' ', first_name), COALESCE(NULLIF(title, 'Sales Representative'), 'Sales Stuff')
FROM employees

