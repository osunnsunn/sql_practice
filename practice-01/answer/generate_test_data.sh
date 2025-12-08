#!/bin/bash

echo "-- start --"

START_DATE="$1"
END_DATE="$2"
CONTAINER_NAME="sql-batch-practice-db"

docker exec -it $CONTAINER_NAME psql -U postgres -d practice_db -c \
"SELECT * FROM generate_test_data('$START_DATE', '$END_DATE');"

echo "-- end --"

#! bash answer/generate_test_data.sh 2025-01-01 2025-01-03 で動作確認済