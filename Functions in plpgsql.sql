CREATE OR REPLACE FUNCTION get_total_number_of_goods() RETURNS bigint as $$
BEGIN
	RETURN sum(units_in_stock)
	FROM products;
END;
$$ LANGUAGE plpgsql

CREATE OR REPLACE FUNCTION get_max_price_from_discountinued() RETURNS real as $$
BEGIN
	RETURN max(unit_price)
	FROM products;
END;
$$ LANGUAGE plpgsql




SELECT get_max_price_from_discountinued

--

CREATE OR REPLACE FUNCTION get_price_boundaries(OUT max_price real, OUT min_price real)  as $$
BEGIN
	max_price := MAX(unit_price) FROM products;
	min_price := MIN(unit_price) FROM products;
	-- we make 2 queries, not optimal
	SELECT MAX(unit_price),MIN(unit_price)
	INTO max_price, min_price
	FROM products;
END;
$$ LANGUAGE plpgsql


SELECT * FROM get_price_boundaries()




CREATE FUNCTION get_customers_by_country(customer_country varchar) RETURNS SETOF customers as $$
BEGIN
	RETURN QUERY
	SELECT *
	FROM customers
	WHERE COUNTRY = customer_country;

END;
$$ LANGUAGE plpgsql;

SELECT * FROM get_customers_by_country('USA')




-- DECLARE VARIABLES IN PLPGSQL FUNCTIONS
CREATE FUNCTION get_square(ab real, bc real, ac real) RETURNS real as $$
DECLARE
	perimeter real;
BEGIN
	perimeter = (ab + bc + ac)/2;
	return sqrt(perimeter *(perimeter - ab)* (perimeter - ac)*(perimeter - bc));
END;
$$ LANGUAGE plpgsql;

SELECT get_square(6,6,6)

-- create function that queries prices about average
CREATE OR REPLACE FUNCTION calc_midprice() RETURNS SETOF products as $$
DECLARE
	avg_price real;
	low_price real;
	high_price real;
BEGIN
	SELECT AVG(unit_price) INTO avg_price
	FROM PRODUCTS;
	
	low_price = avg_price*0.75;
	high_price = avg_price*1.25;
	
	RETURN QUERY
	SELECT * FROM products
	WHERE unit_price BETWEEN low_price AND high_price;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM calc_midprice();


-- IS ELSE LOGIC



-- function with pure logic

CREATE FUNCTION convert_temp_to(temperature real, to_celcius bool DEFAULT true) 
RETURNS REAL AS $$
DECLARE
	result_temp real;
BEGIN
	IF to_celcius THEN
		result_temp = (5.0/9.0)*(temperature-32);
	ELSE 
		result_temp = (9+temperature*(32*5))/5.0;
	END IF;
	RETURN result_temp;
END;
$$ LANGUAGE plpgsql;

SELECT convert_temp_to(80)

--  GET SEASON

CREATE OR REPLACE FUNCTION get_season(month_number int)
RETURNS text AS $$
DECLARE
	season text;
BEGIN
	IF month_number BETWEEN 3 AND 5 THEN
		season= 'SPRING';
	ELSEIF month_number BETWEEN 6 AND 8 THEN
		season= 'SUMMER';
	ELSEIF month_number BETWEEN 9 AND 11 THEN
		season= 'AUTUMN';
	ELSEIF month_number >12 THEN
		season= 'eror';
	ELSEIF month_number <0 THEN
		season= 'eror';
	ELSE
		season= 'WINTER';
	END IF;
	RETURN season;
END;
$$ LANGUAGE plpgsql;



-- loops 
-- While expressions


-- Fibonacchi numbers
CREATE OR REPLACE FUNCTION fib(n int)
RETURNS text AS $$
DECLARE
	counter int = 0;
	i int = 0;
	j int =1 ;
BEGIN
	IF n<1 then
		RETURN 0;
	END IF;
	
	WHILE counter <= n
	LOOP
		counter = counter +1;
		SELECT j, i+j INTO i, j;
	END LOOP;
	
	RETURN I;
END;
$$ LANGUAGE plpgsql;


SELECT FIB(13)


-- Fibonacchi numbers WITH LOOP EXIT WHEN
CREATE OR REPLACE FUNCTION fib(n int)
RETURNS text AS $$
DECLARE
	counter int = 0;
	i int = 0;
	j int =1 ;
BEGIN
	IF n<1 then
		RETURN 0;
	END IF;
	
	
	LOOP
	    EXIT WHEN counter = n+1;
		counter = counter +1;
		SELECT j, i+j INTO i, j;
	END LOOP;
	
	RETURN I;
END;
$$ LANGUAGE plpgsql;




DO $$
BEGIN
	FOR COUNTER IN 1..5 BY 2
	LOOP
		RAISE NOTICE 'Counter:%', counter;
	END LOOP;
END $$;





-- RETURN NEXT

CREATE OR REPLACE FUNCTION returnints() RETURNS SETOF int AS $$
BEGIN 
	RETURN NEXT 1;
	RETURN NEXT 2;
	RETURN NEXT 3;
END;
$$ LANGUAGE plpgsql;


SELECT * FROM returnints();

--
DROP FUNCTION afterchristman()

CREATE FUNCTION afterchristman() RETURNS SETOF products AS $$
DECLARE 
	product record;
BEGIN 
	FOR product IN SELECT * FROM products
	LOOP 
		IF products.category_id in (1,4,8) THEN
			product.unit_price = product.unit_price*0.8;
		ELSEIF products.category_id in (2,3,7) THEN
			product.unit_price = product.unit_price*0.75;
		ELSE 
			product.unit_price = product.unit_price*1.1;
		END IF;
		RETURN NEXT product;
	END LOOP;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM afterchristman();

SELECT * FROM products

-- FUNCTIONS EXERCISES
CREATE OR REPLACE FUNCTION backup() RETURNS void AS $$
	DROP TABLE IF EXISTS backup;
	
	CREATE TABLE backup AS
	SELECT * FROM CUSTOMERS;
-- SELECT * INTO backup()
-- FROM CUSTOMERS
$$ LANGUAGE sql;

SELECT backup();
SELECT COUNT(*) FROM backup


-- avg freight function
CREATE OR REPLACE FUNCTION getavgfreight() RETURNS float8 AS $$
SELECT AVG(FREIGHT)
FROM ORDERS
$$ LANGUAGE sql;


CREATE OR REPLACE FUNCTION randombetween(low int, high int) RETURNS int AS $$
BEGIN
	RETURN floor (random()) + (high - low + 1) + low;
END
$$ LANGUAGE plpgsql;

-- example
select randombetween(1,5)
FROM generate_series(1, 10)

---

CREATE OR REPLACE FUNCTION getsalaryboundsbycity(emp_city varchar, out min_salary numeric, out max_salary numeric) AS $$
	SELECT MIN(salary), Max(salary)
	FROM employees
	WHERE CITY = emp_city
$$ LANGUAGE sql;





CREATE OR REPLACE FUNCTION getOrdersByShipping(ship_method int) 
RETURNS setof orders AS $$
DECLARE
	average numeric;
	maximum numeric;
	middle numeric;
BEGIN
	SELECT MAX(freight) INTO MAXIMUM
	FROM ORDERS
	WHERE SHIP_VIA = ship_method;
	
	
	SELECT AVG(freight) INTO AVERAGE
	FROM ORDERS
	WHERE SHIP_VIA = ship_method;
	
	maximum = maximum * 0.7;
	
	MIDDLE = (MAXIMUM + AVERAGE)/2;
	
	RETURN QUERY 
	SELECT * 
	FROM ORDERS
	WHERE FREIGHT < MIDDLE;
END
$$ LANGUAGE PLPGsql;

-- * _ > < () {} ^ : $ ! :=

SELECT COUNT( * ) FROM getOrdersByShipping(1)

