-- Northwind exercises
-- source https://github.com/eirkostop/SQL-Northwind-exercises

-- Simple SQL Queries
-- date 26.06.2022

-- Q2. Get all Customers alphabetically, by Country and name

SELECT * 
FROM customers
ORDER BY country, contact_name;

--Q4. Get the count of all Orders made during 1997
SELECT count(*) as number_of_orders_1997
FROM orders
WHERE EXTRACT(year from order_date) = 1997

--Q5. Get the names of all the contact persons where the person is a manager, alphabetically
SELECT contact_name
FROM customers
WHERE contact_title like '%Manager%';


SELECT * 
FROM employees
limit 10

--Exercise SQL Queries for JOINS

---1. Create a report for all the orders of 1996 and their Customers (152 rows)
SELECT *
FROM orders o
INNER JOIN Customers c on o.customer_id = c.customer_id
Where EXTRACT(year from o.order_date) = 1996

--Q2. Create a report that shows the number of employees and customers from each city that has employees in it (5 rows)

SELECT e.city AS city, COUNT(DISTINCT e.employee_id) as number_of_employees, 
COUNT(DISTINCT c.customer_id) as number_of_customers
FROM employees e 
LEFT JOIN customers c on e.city = c.city
GROUP BY e.city
ORDER BY e.city

-- Q3. Create a report that shows the number of employees and customers from each city that has customers in it (69 rows)

SELECT c.city AS city, COUNT(DISTINCT c.customer_id) as number_of_customers,
COUNT(DISTINCT e.employee_id) as number_of_employees
FROM employees e 
RIGHT JOIN customers c on e.city = c.city
GROUP BY c.city
ORDER BY c.city


--Q4. Create a report that shows the number of employees and customers from each city (71 rows)

-- just change the type of join to FULL JOIN and add both city columns

SELECT c.city, c.city, COUNT(DISTINCT c.customer_id) as number_of_customers,
COUNT(DISTINCT e.employee_id) as number_of_employees
FROM employees e 
FULL JOIN customers c on e.city = c.city
GROUP BY c.city
ORDER BY c.city

--Exercise SQL Queries for HAVING, WHERE

--1. Create a report that shows the order ids and the associated employee
-- names for orders that shipped after the required date (37 rows)

SELECT o.order_id, e.last_name, e.first_name
FROM orders o
LEFT JOIN employees e on o.employee_id = e.employee_id
WHERE o.shipped_date > o.required_date;

-- Q2. Create a report that shows the total quantity of products 
--(from the Order_Details table) ordered. Only show records for 
-- products for which the quantity ordered is fewer than 200 (5 rows)

SELECT o.product_id, p.product_name, SUM(o.quantity) as total
FROM order_details o 
JOIN products p ON p.product_id = o.product_id
GROUP BY o.product_id, p.product_name
HAVING SUM(o.quantity) < 200
ORDER BY total DESC;

--Q3. Create a report that shows the total number of orders by 
--Customer since December 31, 1996. The report should only return 
--rows for which the total number of orders is greater than 15 (5 rows)

SELECT customer_id, COUNT(order_id) AS total
FROM orders
WHERE order_date > '1996-12-31'
GROUP BY customer_id
HAVING COUNT(order_id) > 15
ORDER BY total

-- That's it for today. 26.06.2022








