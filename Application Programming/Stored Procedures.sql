
CREATE OR REPLACE PROCEDURE find_customer (
    customerId IN NUMBER,
    found OUT NUMBER
) AS
BEGIN
    SELECT customer_id INTO found
    FROM customers
    WHERE customer_id = customerId;

    found := 1;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        found := 0;
    WHEN TOO_MANY_ROWS THEN
        dbms_output.put_line('Error: Multiple customers found with the same ID.');
        found := 0;
    WHEN OTHERS THEN
        dbms_output.put_line('An unexpected error occurred.');
        found := 0;
END find_customer;
/

CREATE OR REPLACE PROCEDURE find_product(
    productId IN NUMBER,
    price OUT products.list_price%TYPE,
    productName OUT products.product_name%TYPE
) AS
    category_id NUMBER;
    current_month NUMBER;
BEGIN
    SELECT LIST_PRICE, PRODUCT_NAME, CATEGORY_ID
    INTO price, productName, category_id
    FROM PRODUCTS
    WHERE PRODUCT_ID = productId;

    current_month := TO_NUMBER(TO_CHAR(SYSDATE, 'MM'));

    IF (category_id IN (2, 5)) AND (current_month IN (11, 12)) THEN
        price := price * 0.9;
    END IF;

EXCEPTION
    WHEN no_data_found THEN
        price := 0;
        productName := NULL;
    WHEN too_many_rows THEN
        DBMS_OUTPUT.PUT_LINE('Error: Multiple rows found for the same product ID.');
        price := 0;
        productName := NULL;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An unexpected error occurred: ' || SQLERRM);
        price := 0;
        productName := NULL;
END;
/
CREATE OR REPLACE PROCEDURE add_order(
    customer_id IN NUMBER,
    new_order_id OUT NUMBER
) AS
BEGIN

    new_order_id := generate_order_id();

    INSERT INTO ORDERS (ORDER_ID, CUSTOMER_ID, STATUS, SALESMAN_ID, ORDER_DATE)
    VALUES (new_order_id, customer_id, 'Shipped', 56, SYSDATE);

    COMMIT;
END;
/
CREATE OR REPLACE FUNCTION generate_order_id
RETURN NUMBER AS
    new_id NUMBER;
BEGIN
    SELECT NVL(MAX(ORDER_ID), 0) + 1 INTO new_id FROM ORDERS;
    RETURN new_id;
END;
/
CREATE OR REPLACE PROCEDURE add_order_item(
    orderId IN order_items.order_id%TYPE,
    itemId IN order_items.item_id%TYPE,
    productId IN order_items.product_id%TYPE,
    quantity IN order_items.quantity%TYPE,
    price IN order_items.unit_price%TYPE
) AS
BEGIN
    INSERT INTO ORDER_ITEMS (ORDER_ID, ITEM_ID, PRODUCT_ID, QUANTITY, UNIT_PRICE)
    VALUES (orderId, itemId, productId, quantity, price);

    COMMIT;
END;
/
CREATE OR REPLACE PROCEDURE customer_order(
    customerId IN NUMBER,
    orderId IN OUT NUMBER
) AS
BEGIN
    SELECT ORDER_ID
    INTO orderId
    FROM ORDERS
    WHERE CUSTOMER_ID = customerId AND ORDER_ID = orderId;

EXCEPTION
    WHEN no_data_found THEN
        orderId := 0;
    WHEN too_many_rows THEN
        DBMS_OUTPUT.PUT_LINE('Error: Multiple rows found for the same order ID and customer.');
        orderId := 0;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An unexpected error occurred: ' || SQLERRM);
        orderId := 0;
END;
/
CREATE OR REPLACE PROCEDURE display_order_status(
    orderId IN NUMBER,
    status OUT orders.status%TYPE
) AS
BEGIN
    SELECT STATUS
    INTO status
    FROM ORDERS
    WHERE ORDER_ID = orderId;

EXCEPTION
    WHEN no_data_found THEN
        status := NULL;
    WHEN too_many_rows THEN
        DBMS_OUTPUT.PUT_LINE('Error: Multiple rows found for the same order ID.');
        status := NULL;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An unexpected error occurred: ' || SQLERRM);
        status := NULL;
END;
/
CREATE OR REPLACE PROCEDURE CANCEL_ORDER (
    orderId IN NUMBER,
    customerId IN NUMBER,
    cancelStatus OUT NUMBER
) AS
    orderStatus VARCHAR2(20);
BEGIN
    DBMS_OUTPUT.PUT_LINE('Input orderId: ' || orderId);
    DBMS_OUTPUT.PUT_LINE('Input customerId: ' || customerId);

    SELECT STATUS
    INTO orderStatus
    FROM ORDERS
    WHERE ORDER_ID = orderId AND CUSTOMER_ID = customerId;

    DBMS_OUTPUT.PUT_LINE('Order Status: ' || orderStatus);

    IF orderStatus = 'Canceled' THEN
        cancelStatus := 1; 
        DBMS_OUTPUT.PUT_LINE('Order already canceled.');
    ELSIF orderStatus = 'Shipped' THEN
        cancelStatus := 2; 
        DBMS_OUTPUT.PUT_LINE('Order cannot be canceled because it is shipped.');
    ELSE
        UPDATE ORDERS
        SET STATUS = 'Canceled'
        WHERE ORDER_ID = orderId AND CUSTOMER_ID = customerId;

        cancelStatus := 3; 
        DBMS_OUTPUT.PUT_LINE('Order successfully canceled.');
        COMMIT;
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        cancelStatus := 0; 
        DBMS_OUTPUT.PUT_LINE('Order not found.');
END;
/
DECLARE
    cancelStatus NUMBER;
BEGIN
    CANCEL_ORDER(113, 50, cancelStatus);
    DBMS_OUTPUT.PUT_LINE('Cancel Status: ' || cancelStatus);
END;

/
CREATE OR REPLACE PROCEDURE GET_ORDER_STATUS (
    orderId IN NUMBER,
    customerId IN NUMBER,
    status OUT VARCHAR2
) AS
BEGIN
    SELECT STATUS
    INTO status
    FROM ORDERS
    WHERE ORDER_ID = orderId AND CUSTOMER_ID = customerId;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        status := 'Order not found';
END;
/
