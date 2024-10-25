//Write a SQL query to display the last name and hire date of all employees 
//who were hired before the employee with ID 101 got hired but after July 2016. 
//Sort the result by the hire date and then employee ID.
// This query returns 9 rows as following.

SELECT 
    last_name, hire_date
FROM 
    employees
WHERE 
    hire_date < (SELECT hire_date 
                FROM employees
                WHERE employee_id = 101)
AND 
    hire_date > last_day(TO_DATE('07-01-2016', 'MM-DD-YYYY'))
ORDER BY 
    hire_date, employee_id ASC;


// Write a SQL query to display customer name and 
// credit limit for customers with lowest credit limit. 
// Sort the result by customer ID.
// This query returns 11 rows as follwing.

SELECT  
    name, credit_limit
FROM 
    customers
WHERE 
    credit_limit = ( select min(credit_limit)
                    from customers)
ORDER BY
    customer_id ASC;
    
// Write a SQL query to display the product ID, product name, and list price 
// of the least paid product(s) (lowest list price) in each category. 
// Sort by category ID and the product ID.
// If your result matches any of the following results, your solution is correct.

SELECT
     category_id, product_id, product_name, list_price
FROM 
    products 
WHERE list_price = any (SELECT MIN(list_price)
                    FROM products
                    GROUP BY category_id)
ORDER BY
    category_id, product_id ASC;

// Write a SQL query to display the category ID and the category
// name of the most expensive (highest list price) product(s).
//This query returns 1 row as following.

SELECT 
    category_id, category_name
FROM 
    product_categories
WHERE 
    category_id = (SELECT category_id
                    FROM products
                    WHERE list_price = (SELECT MAX(list_price)
                    FROM products));

// Write a SQL query to display product name and list price for products in
// category 2 which have the list price greater than ANY highest list price
// in each category. Sort the output by top list prices first and then by
// the product ID.
// Hint: use the ANY clause
// The query returns 20 rows as following.

SELECT 
    product_name,list_price
FROM 
    products
WHERE 
    list_price > ANY (SELECT MAX(list_price)
                        FROM products
                        GROUP BY category_id)
AND 
    category_id = 2
ORDER BY list_price DESC, product_id;

// Find the category or categories contain the lowest price product, and 
// display the corresponding category ID along with the maximum price (list price)
// This query return 1 row as following. 

SELECT  
    category_id, MAX(list_price)
FROM    
    products
WHERE 
    category_id = (SELECT category_id
                    FROM products
                    WHERE list_price = (SELECT MIN(LIST_PRICE)
                    FROM products))
GROUP BY
    category_id;



    

