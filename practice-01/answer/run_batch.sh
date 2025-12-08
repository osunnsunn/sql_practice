#!/bin/bash

echo "-- start --"

target_date="$1"
CONTAINER_NAME="sql-batch-practice-db"

export PGPASSWORD="password"

docker exec -i $CONTAINER_NAME psql -U postgres -d practice_db -c \
"SELECT generate_daily_sales_summary('$target_date');"

if [ $? -ne 0 ]; then
    echo "エラー：集計関数の実行が失敗しました。"
    exit 1
fi

docker exec -i $CONTAINER_NAME psql -U postgres -d practice_db -c \
"\COPY (
    SELECT * 
    FROM daily_sales_summary 
    WHERE summary_date = '$target_date'
) TO 'output_${target_date}.csv' WITH CSV HEADER"

echo "-- end --"