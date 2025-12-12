CREATE OR REPLACE FUNCTION generate_test_data(start_date DATE, end_date DATE)
RETURNS TABLE(generated_order_id INT) AS $$
DECLARE
    cur_date DATE;
    product_id INT;
    new_order_id INT;
BEGIN
    FOR cur_date IN SELECT d::date FROM generate_series(start_date, end_date, interval '1 day') AS d LOOP
        INSERT INTO orders(order_datetime)
        VALUES (cur_date)
        RETURNING order_id INTO new_order_id;

        FOR product_id IN SELECT p.product_id FROM products p LOOP
            INSERT INTO order_details(order_id, product_id, quantity)
            VALUES (new_order_id, product_id, (FLOOR(RANDOM() * 3) + 1)::int);
        END LOOP;

        generated_order_id := new_order_id;
        RETURN NEXT;

    END LOOP;
    RETURN;
END;
$$ LANGUAGE plpgsql;