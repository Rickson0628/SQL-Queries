// Question 1
//Write a query to display the tomorrow’s date in the following format:
//  September 16th of year 2022
//the result will depend on the day when you RUN/EXECUTE this query. 
// Label the column Tomorrow.

    SELECT TO_CHAR(SYSDATE + 1, 'Month DDth "of year" YYYY') AS Tomorrow
    FROM dual;

//Question 2
// Write a query that displays the full name and job title of the manager for
// employees whose job title is "Finance Manager" in the following format:
// Jude Rivera works as Administration Vice President.
// The query returns 1 row.
// Sort the result based on employee ID.


    SELECT FIRST_NAME || ' ' || LAST_NAME || ' works as ' ||  JOB_TITLE AS Question_2
    FROM EMPLOYEES 
    WHERE JOB_TITLE = 'Finance Manager'
    ORDER BY EMPLOYEE_ID;
        
    // Question 3
    
    // For employees hired in November 2016, display the employee’s last name, 
    // hire date and calculate the number of months between the current date and 
    // the date the employee was hired, considering that if an employee worked over 
    // half of a month, it should be counted as one month.
    // Label the column Months Worked.
    // The query returns 5 rows.
    // Sort the result first based on the hire date column
    //and then based on the employee's last name. 
        
        SELECT LAST_NAME, HIRE_DATE, ROUND(MONTHS_BETWEEN(sysdate, hire_date)) AS "Months Worked"
        FROM EMPLOYEES
        WHERE HIRE_DATE BETWEEN TO_DATE('01-NOV-2016','DD-MON-YYYY') 
        AND TO_DATE('30-NOV-2016' ,'DD-MON-YYYY')
        ORDER BY HIRE_DATE, LAST_NAME;
    
//Question 4
//Display each employee’s last name, hire date, and the review date, which is 
//the first Friday after five months of service. Show the result only for those
//hired before January 20, 2016. 
//Label the column REVIEW DATE. 
//Format the dates to appear in the format like:
//TUESDAY, January the Thirty-First of year 2016
//You can use ddspth to have the above format for the day.
//Sort first by review date and then by last name.
//The query returns 6 rows.

    SELECT LAST_NAME, HIRE_DATE, 
    TO_CHAR( NEXT_DAY (ADD_MONTHS(HIRE_DATE, 5), 'FRIDAY'), 'fmDAY, "the "Ddspth" of" Month, YYYY') AS "REVIEW DATE"
    TO_CHAR
    FROM EMPLOYEES
    WHERE HIRE_DATE < TO_DATE('20-JAN-2016', 'DD-MON-YYYY')
    ORDER BY 'REVIEW DATE', LAST_NAME;
  
  
// Question 5    
// For all warehouses, display warehouse id, warehouse name, city, and state. 
// For warehouses with the null value for the state column, display “unknown”.
// Sort the result based on the warehouse ID.
//The query returns 9 rows.
  
   SELECT WAREHOUSE_ID, WAREHOUSE_NAME,
    TRIM(
        CASE WHEN INSTR(WAREHOUSE_NAME, ',') > 0 
            THEN SUBSTR(WAREHOUSE_NAME, 1, INSTR(WAREHOUSE_NAME, ',') -1 )
    
            ELSE WAREHOUSE_NAME
        END
    ) AS city,
    TRIM(
        CASE
            WHEN INSTR(WAREHOUSE_NAME, ',') > 0 THEN
                SUBSTR(WAREHOUSE_NAME, INSTR(WAREHOUSE_NAME, ',')+ 1)
            ELSE 'unknown'
        END
    ) AS state
    FROM WAREHOUSES
ORDER BY WAREHOUSE_ID;


