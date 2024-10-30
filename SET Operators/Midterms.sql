// Question 1. Write a SQL query to display the airline code along with the highest ticket price sold by each airline.
SELECT airline_code, MAX(price)
FROM tickets T
INNER JOIN flights F
ON F.flight_id = T.flight_id
GROUP BY F.airline_code;
// Question 2. Write a SQL query to retrieve the ticket number, flight code, and purchase
// date for all tickets with a price that exceeds the average ticket price across the entire database.
SELECT ticket_id, flight_id, purchase_date
FROM tickets
WHERE price > (SELECT AVG(price)
                FROM tickets);
// Question 3. Write a SQL query to retrieve the ticket ID and rating for all 
// tickets that have a rating exceeding the highest rating of tickets associated with flight
// ID 1. Ensure that the results reflect only those tickets that meet this criterion.
SELECT ticket_id, rating
FROM tickets
WHERE rating > (SELECT MAX(rating)
                FROM tickets
                WHERE flight_id = 1);
                
// Question 4. A study has been conducted to calculate the average customer rating for 
// each flight along with its associated airline. Write a SQL query to display the following 
// information for each flight: flight number, airline code, and the average rating. Ensure that
// the results accurately reflect the average ratings for all flights, and for flights with no ratings,
// display 0. Additionally, round the average rating to two decimal places for clarity.

SELECT F.flight_number, F.airline_code, NVL(ROUND(AVG(T.rating),2), 0)
FROM tickets T
INNER JOIN flights F
ON T.flight_id = F.flight_id
GROUP BY F.fligt_number, F.airline_code;
// Question 5. A statistical analysis has been conducted to identify flights with high customer ratings. 
// Write a SQL query to retrieve the flight ID and airline code for all flights that have
// an average customer rating exceeding 4.
SELECT F.passenger_id, F.airline_code, AVG(T.rating) 
FROM flights F
INNER JOIN tickets T
ON T.flight_id = F.flight_id
GROUP BY F.passenger_id, F.airline_code
WHERE AVG(T.rating) > 4;
// Question 6. For each passenger, retrieve the passenger ID, full name, and the total number 
// of flights they have taken. Ensure that the results accurately reflect the count of flights for each passenger.
SELECT P.passenger_id, P.first_name || ' ' || P.last_name, COUNT(*) 
FROM passenegrs P
INNER JOIN tickets T
ON P.passenger_id = T.passenger_id
GROUP BY P.passenger_id, P.first_name || ' ' || P.last_name;


// Question 7. Write a SQL query to retrieve the following information for all customers:
// Customer ID
// Full Name (combining first name and last name)
// Total Number of Tickets Purchased
// Ensure that customers who have not purchased any tickets are included in the results with a ticket count of 0.

SELECT C.customer_id, C.first_name || ' ' || C.last_name, COUNT(T.ticket_id) 
FROM customers C
LEFT JOIN tickets T
ON C.customer_id = T.customer_id
GROUP BY C.customer_id, C.first_name || ' ' || C.last_name;

// Question 8. Write a SQL query to retrieve the airline code, airline name, and the 
// total number of tickets purchased for each airline. Ensure that the result includes all 
// airlines, even those with zero ticket sales. Sort the results by the total number of tickets in descending order.

SELECT a.airline_code, a.airline_name, COALESCE(COUNT(t.ticket_id), 0) AS total_tickets
FROM airlines a
LEFT JOIN flights f ON a.airline_code = f.airline_code
LEFT JOIN tickets t ON t.flight_id = f.flight_id
GROUP BY a.airline_code, a.airline_name
ORDER BY total_tickets DESC;


// Question 9. A study is being conducted to identify the most popular airlines
// based on ticket sales. Write a SQL query to retrieve the airline code and airline 
// name for airlines that have ticket sales exceeding the average ticket sales across all airlines. 

SELECT A.airline_code, A.airline_name
FROM airlines A
INNER JOIN flights F
ON A.airline_code = F.airline_code
INNER JOIN tickets T
ON F.flight_id = T.flight_id
HAVING T.price > (SELECT AVG(T.price)
                FROM tickets);

// Question 10. We aim to generate a list of all passengers who have flown with American Airlines 
// but not with United Airlines. Please display the passenger ID and the full name of each qualifying 
// passenger. Ensure that the results accurately reflect the specified criteria, excluding any passengers 
// who have flown with United Airlines.

Select P.Passenger_Id, P.First_Nam || ' ' || P.Last_Name
From Passengers P
Inner Join Tickets T
On P.Passenger_Id = T.Passenger_Id
Inner Join Flights F
On T.Flight_Id = F.Flight_Id
Where F.Airline_Code = 'AA'
 
Minus
 
Select P.Passenger_Id, P.First_Nam || ' ' || P.Last_Name
From Passengers P
Inner Join Tickets T
On P.Passenger_Id = T.Passenger_Id
Inner Join Flights F
On T.Flight_Id = F.Flight_Id
Where F.Airline_Code = 'UA';

// Question 11. We aim to generate a list of all passengers who have flown with both American Airlines (AA)
// and United Airlines (UA). Please display the passenger ID and the full name of each qualifying passenger. 
// Ensure that the results accurately reflect the specified criteria, including only those passengers who 
// have flown with both airlines.

Select P.Passenger_Id, P.First_Nam || ' ' || P.Last_Name
From Passengers P
Inner Join Tickets T
On P.Passenger_Id = T.Passenger_Id
Inner Join Flights F
On T.Flight_Id = F.Flight_Id
Where F.Airline_Code = 'AA'
 
INTERSECT
 
Select P.Passenger_Id, P.First_Nam || ' ' || P.Last_Name
From Passengers P
Inner Join Tickets T
On P.Passenger_Id = T.Passenger_Id
Inner Join Flights F
On T.Flight_Id = F.Flight_Id
Where F.Airline_Code = 'UA';


// Question 12. Write a SQL query to retrieve the passenger IDs of passengers who have
// flown with all three airlines present in the dataset.

SELECT passenger_id 
FROM flights F
INNER JOIN tickets T
ON T.flight_id = F.flight_id
WHERE F.airline_code = 'AA'
 
INTERSECT

SELECT passenger_id 
FROM flights F
INNER JOIN tickets T
ON T.flight_id = F.flight_id
WHERE F.airline_code = 'UA'
 
INTERSECT
 
SELECT passenger_id 
FROM flights F
INNER JOIN tickets T
ON T.flight_id = F.flight_id
WHERE F.airline_code = 'DL';

// Question 13. A study aims to identify the most popular season for ticket purchases
//throughout the year. Write a SQL query to display the name of each season (Winter, Spring, Summer, Fall)
// along with the total number of ticket sales for each season.
// Season Definitions for Reference:
// Winter: December 21 to March 19
// Spring: March 20 to June 20
// Summer: June 21 to September 22
// Fall: September 23 to December 20


Select ‘Winter: ‘ || count(ticket_id)
From tickets
where purchase_date between to_date(’12-21-24’,’MM-DD-YY’)
and to_date(’03-19-24’,’MM-DD-YY’)

 
union all
 
Select ‘Spring: ‘ || count(ticket_id)
From tickets
where purchase_date between to_date(’03-20-24’,’MM-DD-YY’)
and to_date(’06-20-24’,’MM-DD-YY’)
 
union all
 
Select ‘Summer: ‘ || count(ticket_id)
From tickets
where purchase_date between to_date(’06-21-24’,’MM-DD-YY’)
and to_date(’09-21-24’,’MM-DD-YY’)
 
union all

Select ‘Fall: ‘ || count(ticket_id)
From tickets
where purchase_date between to_date(’09-23-24’,’MM-DD-YY’)
and to_date(’12-20-24’,’MM-DD-YY’);

// Question 14. A study aims to analyze ticket purchasing trends on a monthly basis. 
// Write a SQL query to display the name of each month along with the total number of tickets purchased during that month.
SELECT to_char(purchase_date, ‘Month’) AS “month”, count(ticket_id)
FROM tickets
GROUP BY to_char(purchase_date, ‘Month’);
select to_char(sysdate + 10, 'FMDD-MONTH-YYYY')
from dual; 
SELECT last_name,TO_CHAR(sysdate, 'Ddspth "of" Month  YYYY   HH:MI')
FROM employees;
SELECT TO_DATE('09-SEP-2023', 'DD-MON-YYYY') AS "Converted Date" FROM dual;