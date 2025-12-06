CREATE OR REPLACE FUNCTION generate_test_data(start_date DATE, end_date DATE)
RETURNS TABLE(generated_order_id INT) AS $$
DECLARE
    cur_date DATE;
    product_record RECORD;
    new_order_id INT;
BEGIN
    cur_date := start_date;

    WHILE cur_date <= end_date LOOP
	
        INSERT INTO orders(order_datetime)
        VALUES (cur_date)
        RETURNING order_id INTO new_order_id;

        FOR product_record IN SELECT product_id FROM products LOOP
            INSERT INTO order_details(order_id, product_id, quantity)
            VALUES (new_order_id, product_record.product_id, 1);
        END LOOP;

        generated_order_id := new_order_id;
        RETURN NEXT;

        cur_date := cur_date + 1;
    END LOOP;
END;
$$ LANGUAGE plpgsql;