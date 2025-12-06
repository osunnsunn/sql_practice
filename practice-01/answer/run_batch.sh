#!/bin/bash

echo "-- start --"

target_date="$1"

export PGPASSWORD="password"

psql -U postgres -d practice_db -h localhost -p 15432 -c \
"SELECT generate_daily_sales_summary('$target_date');"

psql -U postgres -d practice_db -h localhost -p 15432 -c \
"\COPY (
    SELECT * 
    FROM daily_sales_summary 
    WHERE summary_date = '$target_date'
) TO 'output_${target_date}.csv' WITH CSV HEADER"

echo "-- end --"