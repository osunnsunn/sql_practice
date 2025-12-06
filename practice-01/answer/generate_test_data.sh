#!/bin/bash

echo "-- start --"

START_DATE="$1"
END_DATE="$2"

PGPASSWORD="yourpassword" psql -U postgres -d practice_db -h localhost -p 15432 -c \
"SELECT * FROM generate_test_data('$START_DATE', '$END_DATE');"

echo "-- end --"