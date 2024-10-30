// Display the total number of products and the total order amount for each order 
// id where the total number of products is less than 70. Sort the result based 
// on the order id. See the labels for the column labels in your result:
// This query returns 4 rows.
//Order ID    Total Quantity  Total Amount
SELECT order_id AS "Order ID",
    SUM(quantity) AS "Total Quantity",
    SUM(unit_price * quantity) AS "Total Amount"
FROM order_items
GROUP BY order_id
HAVING SUM (quantity) <  70
ORDER BY order_id ASC;

//For all customer, display customer number, customer full name,
// and the total number of orders issued by the customer. 
// If the customer does not have any orders, the number of orders shows 0.
// Display only customers whose customer name starts with 'G' and ends with 's'.
// Sort the result first by the number of orders and then by customer ID.
// See the column labels in the output:
//CUSTOMER_ID  NAME          Number of Orders
// This query returns 6 rows.
SELECT 
    customers.customer_id, 
    customers.NAME, 
    COALESCE(COUNT(orders.order_id),0) AS "Number of Orders"
FROM 
    customers 
LEFT JOIN 
    orders ON customers.customer_id = orders.customer_id
WHERE 
    customers.NAME LIKE 'G%' AND customers.NAME LIKE '%s'
GROUP BY 
    customers.customer_id, customers.NAME
ORDER BY 
    "Number of Orders" ASC, customers.customer_id ASC;
    

// Write a SQL statement to display Category ID, Category Name, the average
// list_price, and the number of products for all categories in the product_categories table.
// For categories in product_categories that do not have any matching rows in products,
// the average price and the number of products are shown as 0.
// Round the average price to one decimal places.
// Sort the result by category ID.
// See the output labels:
// CATEGORY_ID     CATEGORY_NAME    Average Price   Number of Products
// This query returns 5 rows.
SELECT 
    pc.category_id, pc.category_name, 
    round(COALESCE(AVG(p.list_price),0),1) AS "Average Price",
    COUNT(p.product_id) AS "Number of Products"
    
FROM product_categories pc
FULL OUTER JOIN 
    products p ON pc.category_id = p.category_id
GROUP BY 
    pc.category_id, pc.category_name
ORDER BY
    pc.category_id;
    
    

// Write a SQL statement to display the number of different products 
// and the total quantity of all products for each warehouse.
// Sort the result according to the quantity of all products.
// see the output column labels:
//WAREHOUSE_ID  Number of Different Products   Quantity of all products
// This query returns 9 rows.

SELECT 
    W.warehouse_id, 
    COUNT(DISTINCT P.product_name) AS "Number of Different Products",
    SUM(I.quantity) AS "Quantity of all products"
FROM inventories I
LEFT JOIN
    products P ON I.product_id = P.product_id
LEFT JOIN
    warehouses W ON I.warehouse_id = W.warehouse_id
GROUP BY W.warehouse_id
ORDER BY "Quantity of all products" ;

// Write a SQL statement to display the number of warehouses for each region.
// Display the region id, the region name and the number
// of warehouses in your result.
// Sort the result by the region id.
// REGION_ID         Region Name      Number of Warehouses

SELECT 
    r.region_id,
    r.region_name,
    count(w.warehouse_id) as "Number of Warehouses"
FROM regions r
INNER JOIN 
    countries c on r.region_id = c.region_id
INNER JOIN 
    locations l on c.country_id = l.country_id
INNER JOIN 
    warehouses w on w.location_id = l.location_id
GROUP BY r.region_id, r.region_name
ORDER BY region_id;
    



