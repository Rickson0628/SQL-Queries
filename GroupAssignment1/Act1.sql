--******************************************************************
-- Group 16
-- Student1 Name: John Richard P. Bozar Student1 ID: 167550235
-- Student2 Name: Rickson Bozar ID: 167549237
-- Student3 Name: Your Name Student3 ID: #########
-- Date: The date of assignment completion 2024-10-16
-- Purpose: Assignment 1 - DBS311
-- All the content other than your sql code should be put in comment block.
-- Include your output in a comment block following with your sql code.
-- Remember add ; in the end of your statement for each question.
--******************************************************************

-- Q1 solution
--Write a query to display employee ID, first name, last name, and hire date for employees
--who have been hired before the first employee hired in June 2016 but two months after
--the last employee hired in February 2016.
--Sort the result by hire date and employee ID.
--The query returns 7 rows.
--Include both the query and the result in your answer.
--See the output columns: 

  SELECT employee_id AS "EMPLOYEE_ID", first_name AS "FIRST_NAME", last_name AS "LAST_NAME", hire_date AS "HIRE_DATE"
  FROM employees
  WHERE hire_date < (SELECT MIN(hire_date) FROM employees WHERE hire_date >= TO_DATE('2016-06-01', 'YYYY-MM-DD'))
  AND hire_date > ADD_MONTHS((SELECT MAX(hire_date) FROM employees WHERE hire_date < TO_DATE('2016-03-01', 'YYYY-MM-DD')), 2)
  ORDER BY hire_date, employee_id;

/*RESULT
EMPLOYEE_ID FIRST_NAME LAST_NAME HIRE_DATE
----------- ---------- --------- ---------- 
97	Harriet	Ferguson	16-04-24
23	Jackson	Coleman	16-05-01
75	Imogen	Boyd	16-05-11
16	Alex	Sanders	16-05-18
5	Nathan	Cox	16-05-21
98	Amber	Rose	16-05-23
79	Esme	Warren	16-05-24
*/

-- Q2 solution

/*Write a SQL query to display country ID and country name for countries with more than
one location. Answer this question without using the group/aggregate functions (count,
sum, min, max, avg, …).
Sort the result by country ID.
The query returns 6 rows.
Include both the query and the result in your answer.
See the output columns: */
  SELECT DISTINCT c.country_id AS "Country ID",  c.country_name AS "Country Name"
  FROM countries c
  JOIN locations l ON c.country_id = l.country_id
  WHERE EXISTS (SELECT 1 FROM locations l2 WHERE l2.country_id = c.country_id AND l2.location_id <> l.location_id)
  ORDER BY c.country_id;
/*
Country ID   Country Name
----------- ------------- 
CA	Canada
CH	Switzerland
IT	Italy
JP	Japan
UK	United Kingdom
US	United States of America
*/


-- Q3 solution
/*
Use the previous query and SET Operator(s) to display country ID and country name for
counties with only one location assigned to them.
Sort the result by country ID.
You are not allowed to use COUNT or SUM.
The query returns 8 rows.
Include both the query and the result in your answer. 
*/
SELECT country_id AS "Country ID", country_name AS "Country Name"
FROM countries c
WHERE EXISTS (
    SELECT 1
    FROM locations l
    WHERE l.country_id = c.country_id
    GROUP BY l.country_id
    HAVING COUNT(l.location_id) = 1
)
ORDER BY country_id;
/*
Country ID Country Name
----------- -------------
AU	Australia
BR	Brazil
CN	China
DE	Germany
IN	India
MX	Mexico
NL	Netherlands
SG	Singapore
*/
-- Q4 solution
/*
4. Write a SQL query to display customers that have been ordered multiple times in one
month in 2017.
Display customer ID, month name, and the number of times the customer has ordered on
that month.
Sort the result by order date and customer ID.
The query returns 2 rows.
Include both the query and the result in your answer.
See the following output columns:
Customer ID Month Number of orders
*/
SELECT customer_id AS "Customer ID", TO_CHAR(order_date, 'Month') AS "Month Number", COUNT(order_id) AS "Number of orders"
FROM orders
WHERE EXTRACT(YEAR FROM order_date) = 2017
GROUP BY customer_id, TO_CHAR(order_date, 'Month')
HAVING COUNT(order_id) > 1
ORDER BY TO_CHAR(order_date, 'Month'), customer_id;
/*
Customer ID Month Number of orders
----------- ---------- ----------------
5	        April    	2
48	      March    	2
*/
-- Q5 solution
/*
5. Write a query to display customer ID and customer name for customers who have
purchased all these three products: Products with ID 20 and 95.
Sort the result by customer ID.
The query returns 2 row.
Include both the query and the result in your answer.
*/
SELECT DISTINCT c.customer_id AS "CUSTOMER ID", c.name AS "NAME"
FROM customers c
JOIN orders o1 ON c.customer_id = o1.customer_id
JOIN order_items oi1 ON o1.order_id = oi1.order_id
JOIN orders o2 ON c.customer_id = o2.customer_id
JOIN order_items oi2 ON o2.order_id = oi2.order_id
WHERE oi1.product_id = 20
  AND oi2.product_id = 95
ORDER BY c.customer_id;
/*
CUSTOMER ID NAME
----------- ----
3	        US Foods Holding
16	      Aflac
*/
-- Q6 solution
/*
6. Write a query to display employee ID and the number of orders for employees with the
number of orders (sales) above average of number of orders managed by a salesperson.
Sort the result by employee ID.
The query returns three rows.
Include both the query and the result in your answer.
See the following output:
*/
SELECT e.employee_id AS "Employee ID", COUNT(o.order_id) AS "Number of Orders"
FROM employees e
JOIN orders o ON e.employee_id = o.salesman_id
GROUP BY e.employee_id
HAVING COUNT(o.order_id) > (
  SELECT AVG(order_count)
  FROM (
    SELECT COUNT(o2.order_id) AS order_count
    FROM employees e2
    JOIN orders o2 ON e2.employee_id = o2.salesman_id
    GROUP BY e2.employee_id
  )
)
ORDER BY e.employee_id;
/*
Employee ID Number of Orders
----------- ----------------
55	        10
62	        13
64	        12
*/
-- Q7 solution
/*
7.Write a query to display the month number, month name, total number of customers with
orders in each month, and total sales amount for each month in 2017.
Sort the result according to month number.
Include both the query and the result in your answer.
The query returns 10 rows.
*/
SELECT 
    TO_CHAR(o.order_date, 'MM') AS "Month Number",
    TO_CHAR(o.order_date, 'Month') AS "Month Total",
    COUNT(DISTINCT o.customer_id) AS "Total Number of customers",
    SUM(oi.quantity * oi.unit_price) AS "Sales Amount"
FROM 
    orders o
JOIN 
    order_items oi ON o.order_id = oi.order_id
WHERE 
    TO_CHAR(o.order_date, 'YYYY') = '2017'
GROUP BY 
    TO_CHAR(o.order_date, 'MM'), 
    TO_CHAR(o.order_date, 'Month')
ORDER BY 
    month_number;
/*
Month Number Month Total Number of customers Sales Amount
------------ ----- ------------------------- ------------
01	            January  	    5	    2281459.09
02	            February 	    13	    7919446.52
03	            March    	    3	    2246625.47
04	            April    	    1	    609150.35
05	            May      	    4	    1367115.47
06	            June     	    1	    926416.51
08	            August   	    5	    2539537.86
09	            September	    4	    1675983.52
10	            October  	    2	    2040864.95
11	            November 	    1	    307842.27
*/
-- Q8 solution
/*
Write a query to display month number, month name, and average sales amount for
months with the average sales amount greater than average sales amount in 2017. Round
the average amount to two decimal places. Sort the result by the month number. The
query returns 5 rows. Display the result for only 2017 in the main query. Include both the
query and the result in your answer. See the output columns: 
*/
SELECT EXTRACT(MONTH FROM order_date) AS "Month Number",
       TO_CHAR(order_date, 'Month') AS "Month Average",
       ROUND(AVG(quantity * unit_price), 2) AS "Average Sales Amount"
FROM ORDERS o
JOIN ORDER_ITEMS oi
  ON o.order_id = oi.order_id
WHERE EXTRACT(YEAR FROM order_date) = 2017
GROUP BY EXTRACT(MONTH FROM order_date), TO_CHAR(order_date, 'Month')
HAVING ROUND(AVG(quantity * unit_price), 2) > (
    SELECT ROUND(AVG(quantity * unit_price), 2)
    FROM ORDERS o
    JOIN ORDER_ITEMS oi
      ON o.order_id = oi.order_id
    WHERE EXTRACT(YEAR FROM order_date) = 2017
)
ORDER BY month_number;
/*
Month Number Month Average Sales Amount
------------ ----- --------------------
2	    February 	93169.96
3	    March    	89865.02
6	    June     	132345.22
10	    October  	92766.59
11	    November 	153921.14
*/

-- Q9 solution
/*
Write a query to display first names in EMPLOYEES that start with letter B but do not
exist in CONTACTS.
Sort the result by first name.
The query returns 2 rows.
Include both the query and the result in your answer.
See the sample output.
*/
SELECT first_name AS "First Name"
FROM EMPLOYEES
WHERE first_name LIKE 'B%'
  AND first_name NOT IN (SELECT first_name FROM CONTACTS)
ORDER BY first_name;
/*
First Name
-----------
Bella
Blake
*/
-- Q10 solution
/*
. Write a query to calculate the values corresponding to each line and generate the
following output including the calculated values. Include your query and the query result
in your answer.
*/
SELECT 'Number of employees with total order amount over average order amount: ' || COUNT(*) AS description
FROM (
    SELECT o.salesman_id
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY o.salesman_id
    HAVING SUM(oi.quantity * oi.unit_price) > (
        SELECT AVG(total_order_amount)
        FROM (
            SELECT SUM(oi2.quantity * oi2.unit_price) AS total_order_amount
            FROM orders o2
            JOIN order_items oi2 ON o2.order_id = oi2.order_id
            GROUP BY o2.salesman_id
        )
    )
)
UNION ALL
-- Number of employees with total number of orders greater than 10
SELECT 'Number of employees with total number of orders greater than 10: ' || COUNT(*) AS description
FROM (
    SELECT o.salesman_id
    FROM orders o
    GROUP BY o.salesman_id
    HAVING COUNT(o.order_id) > 10
)
UNION ALL
-- Number of employees with no orders
SELECT 'Number of employees with no orders: ' || COUNT(*) AS description
FROM employees e
LEFT JOIN orders o ON e.employee_id = o.salesman_id
WHERE o.salesman_id IS NULL
UNION ALL
-- Number of employees with orders
SELECT 'Number of employees with orders: ' || COUNT(DISTINCT o.salesman_id) AS description
FROM orders o;

/*
Number of employees with total order amount over average order amount: 2
Number of employees with total number of orders greater than 10: 3
Number of employees with no orders: 98
Number of employees with orders: 9

*/