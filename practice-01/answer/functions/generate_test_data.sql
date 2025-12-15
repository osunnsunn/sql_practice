CREATE OR REPLACE FUNCTION generate_test_data(start_date DATE, end_date DATE)
RETURNS TABLE(generated_order_id INT) AS $$
DECLARE
    cur_date DATE;
    new_order_id INT;
    loop_order INT;
    i INT;
    random_product_id INT;
    random_quantity INT;
BEGIN
    FOR cur_date IN SELECT d::date FROM generate_series(start_date, end_date, interval '1 day') AS d LOOP
        INSERT INTO orders(order_datetime)
        VALUES (cur_date)
        RETURNING order_id INTO new_order_id;

        loop_order := FLOOR(RANDOM() * 3 + 1);

        FOR i IN 1..loop_order LOOP
            SELECT p.product_id FROM products p ORDER BY RANDOM() LIMIT 1 INTO random_product_id;
            random_quantity := FLOOR(RANDOM() * 3 + 1);
            INSERT INTO order_details(order_id, product_id, quantity)
            VALUES (new_order_id, random_product_id, random_quantity);
        END LOOP;

        generated_order_id := new_order_id;
        RETURN NEXT;

    END LOOP;
    RETURN;
END;
$$ LANGUAGE plpgsql;