set serveroutput on;

CREATE OR REPLACE PROCEDURE calculateSales IS
  CURSOR curr IS
    SELECT o.customer_id, SUM(oi.quantity * oi.unit_price) AS totalSales
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY o.customer_id
    HAVING COUNT(o.order_id) > 4;

  customer_record curr%ROWTYPE;

BEGIN
  OPEN curr;

  LOOP
    FETCH curr INTO customer_record;

    EXIT WHEN curr%NOTFOUND;

    DBMS_OUTPUT.PUT_LINE('Customer ID: ' || customer_record.customer_id || 
                         ' | Total Sales: ' || customer_record.totalSales);

  END LOOP;

  CLOSE curr;

END calculateSales;
/


/
begin
calculateSales;
end;
/


CREATE OR REPLACE PROCEDURE displayLocations AS
    CURSOR curr IS
        SELECT W.WAREHOUSE_ID, L.CITY, L.STATE, L.COUNTRY_ID
        FROM WAREHOUSES W
        JOIN LOCATIONS L ON W.LOCATION_ID = L.LOCATION_ID;

    rec curr%ROWTYPE;
BEGIN
    OPEN curr;

    LOOP
        FETCH curr INTO rec;
        EXIT WHEN curr%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('Warehouse ID: ' || rec.WAREHOUSE_ID ||
                             ', City: ' || rec.CITY ||
                             ', State: ' || rec.STATE ||
                             ', Country ID: ' || rec.COUNTRY_ID);
    END LOOP;

    CLOSE curr;
END;
/
BEGIN
    displayLocations();
END;
/