/*
Write an Oracle PL/SQL code (a stored procedure or a function) named check_number. 
The PL/SQL code gets an integer value as a parameter and checks if a given number is positive,
negative, or zero. IT display an appropriate message based on the condition.
See the following messages:
If the number is positive, display:
This is a positive number.
If the number is negative, display
This is a negative number.
If the number is zero, display
The number is zero.
*/

CREATE OR REPLACE PROCEDURE check_number(givenNumber IN number) 
AS
BEGIN
    CASE 
    WHEN givenNumber > 0
        THEN DBMS_OUTPUT.PUT_LINE('This is a positive number.');
    WHEN givenNumber < 0 
        THEN DBMS_OUTPUT.PUT_LINE('This is a negative number.');
    WHEN givenNumber = 0 
        THEN DBMS_OUTPUT.PUT_LINE('The number is zero.');
    END CASE;
END check_number;
/

SET SERVEROUTPUT ON;
BEGIN
    check_number(2);
    check_number(-5);
    check_number(0);
END;
/
/*
Write an Oracle PL/SQL code named factorial that gets an integer as its parameter. 
It calculates the factorial of a given number using a loop. It display the calculated factorial value.
See the sample output:
The factorial of 3 is 6.
To calculate the factorial:
n! = n × (n?1)!
0! = 1
1! = 1
2! = 2 x 1 = 2
3! = 3 x 2 x 1 = 6
4! = 4 x 3 x 2 x 1 = 24
5! = 5 x 4 x 3 x 2 x 1 = 120
*/
CREATE OR REPLACE PROCEDURE factorial(givenNumber IN NUMBER) 
AS
    i NUMBER := givenNumber;
    result NUMBER := 1;
BEGIN
    IF givenNumber < 0 THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: negative numbers.');
    ELSIF givenNumber = 0 THEN
        DBMS_OUTPUT.PUT_LINE('The factorial of 0 is 1.');
    ELSE
        WHILE i > 0 LOOP
            result := result * i;
            i := i - 1;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('The factorial of ' || givenNumber || ' is ' || result || '.');
    END IF;
END factorial;
/

SET SERVEROUTPUT ON;

BEGIN
    factorial(5);
    factorial(0);
    factorial(-5);
END;
/

/*
Write an Oracle PL/SQL code named total to calculates the sum of all the integer numbers 
from 1 to a given integer number using a loop. The stored procedure or the function gets an 
integer value as its parameter and displays the sum.
See the sample:
If you pass 5 to the stored procedure of function:
total = 5 + 4 + 3 + 2 + 1
or
total = 1 + 2 + 3 + 4 + 5
To calculate the total, you need to use a loop.
The total is 15.
*/
CREATE OR REPLACE PROCEDURE sum(givenNumber IN NUMBER) 
AS
    i NUMBER := givenNumber;
    result NUMBER := 0;
BEGIN
    IF givenNumber < 0 THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: negative numbers.');
    ELSIF givenNumber = 0 THEN
        DBMS_OUTPUT.PUT_LINE('The sum of 0 is 0.');
    ELSE
        WHILE i > 0 LOOP
            result := result + i;
            i := i - 1;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('The sum of ' || givenNumber || ' is ' || result || '.');
    END IF;
END sum;
/
SET SERVEROUTPUT ON;

BEGIN
    sum(4);
    sum(0);
    sum(-5);
END;
/

/*
Write an Oracle PL/SQL code named even_number to print all the even numbers between
1 and the given integer value passed as the parameter.
See the sample output:
Even numbers between 1 and 6:
2
4
6
*/

CREATE OR REPLACE PROCEDURE even_number(givenNumber IN NUMBER)
AS
    i NUMBER := 1; 
BEGIN
    IF givenNumber = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Even number between 0 and 0 is 0.');
    ELSIF givenNumber = 1 THEN
        DBMS_OUTPUT.PUT_LINE('No even number between 1.');
    ELSIF givenNumber = -1 THEN
        DBMS_OUTPUT.PUT_LINE('No even number between -1.');
    ELSIF givenNumber < 0 THEN
        DBMS_OUTPUT.PUT_LINE('Even negative numbers between 0 and ' || givenNumber || ':');
        WHILE i >= givenNumber LOOP
            IF MOD(i, 2) = 0 THEN
                DBMS_OUTPUT.PUT_LINE(i);
            END IF;
            i := i - 1;  
        END LOOP;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Even numbers between 1 and ' || givenNumber || ':');
        WHILE i <= givenNumber LOOP
            IF MOD(i, 2) = 0 THEN
                DBMS_OUTPUT.PUT_LINE(i);
            END IF;
            i := i + 1;  
        END LOOP;
    END IF;
END even_number;
/
SET SERVEROUTPUT ON;

BEGIN
    even_number(6);    
    even_number(1);    
    even_number(0);    
    even_number(-5);   
END;
/

