CREATE OR REPLACE FUNCTION generate_daily_sales_summary(target_date DATE)
RETURNS VOID AS $$
BEGIN
    --日付データをリセット
    DELETE FROM daily_sales_summary
    WHERE summary_date = target_date;

    INSERT INTO daily_sales_summary (
        summary_date, product_id, 
        total_quantity_sold, 
        total_sales_amount
    )
    SELECT
        target_date AS summary_date, --日付
        od.product_id, --商品ID
        SUM(od.quantity) AS total_quantity_sold, --注文数
        SUM(od.quantity * p.price) AS total_sales_amount --合計金額
    FROM order_details od --テーブル
    JOIN orders o ON od.order_id = o.order_id --注文日
    JOIN products p ON od.product_id = p.product_id --商品名・金額
    WHERE DATE(o.order_datetime) = target_date --指定日だけ
    GROUP BY od.product_id; --商品IDでグループ化

END;
$$ LANGUAGE plpgsql;