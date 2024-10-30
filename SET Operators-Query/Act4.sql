// Q5
// Write a SQL query to display location ID and warehouse ID
// for all locations, including locations without a warehouse.
// You are not allowed to use JOINs.
// First display locations with no warehouse and then locations with a warehouse .
// For locations with no warehouse, display NULL for the warehouse ID.
// The query returns 23 rows. See the following output:

SELECT location_id, NULL AS warehouse_id
FROM locations
WHERE location_id NOT IN (SELECT location_id FROM warehouses)
UNION ALL
SELECT location_id, warehouse_id
FROM warehouses;

//  Q4
// Write a SQL query to display contacts who share the first name and the first
// letter of the last name (case-sensitive) with an employee(s).
// You are not allowed to use JOINs in this query.
//Sort the result by first name and the first letter of last name.
// The query returns 1 row. See the output columns:
// FIRST_NAME  First Letter of Last Name
---------- ----------------------------

SELECT first_name, substr(last_name, 1, 1) AS "first letter of last name"
FROM contacts 
INTERSECT
SELECT first_name, substr(last_name, 1, 1) AS "first letter of last name"
FROM employees
ORDER BY first_name,"first letter of last name" ;


//  Q3
// Write a SQL query to display the number of customers with orders and
// the number of sales persons who have generated orders. Please display 
// the numbers as the following output.
// REPORT                                  
-------------------------------------------------------------------------
// Number of customers with orders: ??
// Number of sales persons: ?

SELECT 'Number of customers with orders: ' || COUNT(*) AS "report"
FROM customers
WHERE customer_id IN (SELECT customer_id
                    FROM orders) 
UNION
SELECT 'Number of sales persons: ' || COUNT(DISTINCT(salesman_id)) AS "report"
FROM orders;


//  Q2  
// Write a SQL query to display number of customers with no order.
// You are not allowed to use JOINs to answer this question.
// The query returns 1 row. See the following output column:
// Number of Customers 
---------------------------------
SELECT COUNT(*) AS "number of customers"
FROM customers
WHERE customer_id NOT IN (SELECT DISTINCT customer_id 
                        FROM  orders);
                        

// Q1
// Write a SQL query to show the total number of customers and employees in the database.
// The query returns one row.
// Please see the following output:
//Report                                   
-----------------------------------------------------------
// Total number of customers and employees: XXX
SELECT 'Total number of customers and employees: ' || SUM(total) AS REPORT
FROM (
    SELECT COUNT(*) AS total
    FROM employees
    UNION 
    SELECT COUNT(*) AS total
    FROM customers);
    




