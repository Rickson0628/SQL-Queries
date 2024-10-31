/*
Question 1
Create a store procedure that accepts a string as input and prints out the capitalized string 
along with the number of characters in the string in a format as the following examples shows.
Input: flower
FLOWER has 6 characters.
Input: Te$t
TE$T has 4 characters.
The procedure display a proper error message if any error occurs.
*/
CREATE OR REPLACE PROCEDURE STRINGMANIPULATE(WORD IN VARCHAR)
IS
    CAPITALIZED VARCHAR(50);
    NUMBERLETTERS NUMBER;
BEGIN
    NUMBERLETTERS := LENGTH(WORD);
    CAPITALIZED := UPPER(WORD);
    DBMS_OUTPUT.PUT_LINE(CAPITALIZED || ' has ' || NUMBERLETTERS || ' characters.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('unknown error');
END STRINGMANIPULATE;
/
SET SERVEROUTPUT ON;

-- Testing the procedure
BEGIN
    STRINGMANIPULATE('flower');
    STRINGMANIPULATE('TE$T');
END;
/

/*
Question 2
Write a store procedure that takes an integer number as an employee ID and prints 
the number of years that employee has been working in the company. Truncate the number
of years to the integer part.
See the following sample output:
The employee with ID 1004 has worked 5 years.
The values in the sample output are random numbers and may not match the real numbers in the database. 
The procedure display a proper error message if any error occurs.*/

CREATE OR REPLACE PROCEDURE EMPLOYEE_YEARS (id IN NUMBER)
IS
    years_worked NUMBER;
BEGIN 
    SELECT TRUNC(MONTHS_BETWEEN(SYSDATE, hire_date) / 12)
    INTO years_worked
    FROM employees
    WHERE employee_id = id;
    DBMS_OUTPUT.PUT_LINE('The employee with ID ' || id || ' has worked ' || years_worked || ' years.');
EXCEPTION 
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No employee found with ID ' || id || '.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred while retrieving the employee data.');
END EMPLOYEE_YEARS;
/
SET SERVEROUTPUT ON;
BEGIN
    EMPLOYEE_YEARS(1004);  
END;
/

/*Question 3
Create a stored procedure named find_product. This procedure gets an integer number 
as product ID and prints the product name, list price, category name for that product .
The procedure gets a value as the product ID of type NUMBER.
See the following sample output for product ID 132: 
Product name: Intel Core i7-5930K
List price: 554.99
Category name: CPU
The procedure display a proper error message if any error occurs.
*/
CREATE OR REPLACE PROCEDURE find_product (id IN NUMBER)
IS
    productName VARCHAR(50);
    price NUMBER;
    categoryName VARCHAR(50);
BEGIN
    SELECT p.product_name, p.list_price, pc.category_name
    INTO productName, price, categoryName
    FROM products p
    INNER JOIN product_categories pc
    ON p.category_id = pc.category_id
    WHERE p.product_id = id;

    DBMS_OUTPUT.PUT_LINE('Product name: ' || productName);
    DBMS_OUTPUT.PUT_LINE('List price: ' || price);
    DBMS_OUTPUT.PUT_LINE('Category name: ' || categoryName);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No product found with ID ' || id || '.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred while retrieving the product data.');
END find_product;
/
SET SERVEROUTPUT ON;
BEGIN
    find_product(132);  
END;
/

/*
NOTE: For this question, create a table exactly the same as the products table.
CREATE TABLE new_products AS
SELECT *
FROM products;
Do not include the create statement in your answer.
Use this new_products table to finish the following update on list prices.


The company applies a yearly price increase of 2% to all products in certain categories if
it satisfy a certain amount limit. Write a stored procedure takes an integer parameter representing 
the category ID, and a numerical parameter of type NUMBER(9,2) as amount. The stored procedure will 
increase the list price of all products in the given category by 2% only if the average list price 
of that category is lower than the provided amount (before the increasing).
The procedure has two parameters:
•  categoryID in NUMBER
•  amount in NUMBER

CREATE OR REPLACE PROCEDURE updatePrice(categoryID in number, amount in NUMBER)
IN 
     
Name your procedure as newprice. In your procedure, if it updates the new_products successfully, 
a message of the number of the updated rows should be returned. 
The procedure display a proper error message if any error occurs. See the following sample outputs:
Test1:
BEGIN
  newprice(2, 10000);
END;
Output1:
50 rows are updated.
Test2:
BEGIN
  newprice(1, 500);
END;
Output2 ( just a reference ):
Average of 1 is 1386.97, which is no lower than 500. We won't update the price!
*/
CREATE OR REPLACE PROCEDURE newprice(categoryID IN NUMBER, amount IN NUMBER)
IS
    avg_price NUMBER(9,2);
    rows_updated NUMBER;
BEGIN
    SELECT AVG(list_price)
    INTO avg_price
    FROM new_products
    WHERE category_id = categoryID;

    IF avg_price < amount THEN
        UPDATE new_products
        SET list_price = list_price * 1.02
        WHERE category_id = categoryID;
        rows_updated := SQL%ROWCOUNT;
        
        DBMS_OUTPUT.PUT_LINE(rows_updated || ' rows are updated.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Average of ' || categoryID || ' is ' || avg_price || 
                             ', which is no lower than ' || amount || '. We won''t update the price!');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred');
END newprice;
/
BEGIN
  newprice(2, 10000);
END;
/
BEGIN
   newprice(1, 500);
END;
/
/*
Question 5
The company needs a report that shows three categories of customers based on their 
credit limits: low, average, and high. To determine the category of customers, the
minimum credit limit, maximum credit limit, and the average credit limit of all 
customers must be calculated.

If the credit limit is less than (average credit limit + minimum credit limit) / 2, 
then the customer’s credit limit is low.

If the credit limit is greater than (maximum credit limit + average credit limit) / 2,
then the customer’s credit limit is high.

If the credit limit is between (average credit limit + minimum credit limit) / 2 
and (maximum credit limit + average credit limit) / 2, then the customer’s credit limit is average.
Write a procedure named creditreport to show the number of customers in each category:

See the following sample output:

The number of customers with average credit limit: 23
The number of customers with high credit limit: 55
The number of customers with low credit limit: 17 

The values in the above examples are just random values and may not match the real numbers in your result.

The procedure has no parameter. First, you need to find the average, minimum, and 
maximum credit limit in your database and store them into variables avgCredit, minCredit, and maxCredit.
You need more three variables to store the number of customers in each category: avg_count, high_count, low_count
Make sure you choose a proper type for each variable. You may need to define more variables based on your solution.
The procedure display a proper error message if any error occurs.
*/  
CREATE OR REPLACE PROCEDURE creditreport
IS
    minCredit NUMBER;
    maxCredit NUMBER;
    avgCredit NUMBER;
    
    avg_count NUMBER := 0;
    high_count NUMBER := 0;
    low_count NUMBER := 0;
BEGIN
  
    SELECT MIN(CREDIT_LIMIT), MAX(CREDIT_LIMIT), AVG(CREDIT_LIMIT)
    INTO minCredit, maxCredit, avgCredit
    FROM CUSTOMERS;

    SELECT COUNT(*)
    INTO low_count
    FROM CUSTOMERS
    WHERE CREDIT_LIMIT < (avgCredit + minCredit) / 2;

    SELECT COUNT(*)
    INTO high_count
    FROM CUSTOMERS
    WHERE CREDIT_LIMIT > (maxCredit + avgCredit) / 2;

    SELECT COUNT(*)
    INTO avg_count
    FROM CUSTOMERS
    WHERE CREDIT_LIMIT BETWEEN (avgCredit + minCredit) / 2 AND (maxCredit + avgCredit) / 2;

    DBMS_OUTPUT.PUT_LINE('The number of customers with average credit limit: ' || avg_count);
    DBMS_OUTPUT.PUT_LINE('The number of customers with high credit limit: ' || high_count);
    DBMS_OUTPUT.PUT_LINE('The number of customers with low credit limit: ' || low_count);

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred');
END creditreport;
/
SET SERVEROUTPUT ON;
BEGIN 
 creditreport;
END;
/