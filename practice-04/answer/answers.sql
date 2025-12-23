CREATE OR REPLACE PROCEDURE calculate_monthly_salary_summary(
    target_year_month CHAR(7)
)
AS $$
DECLARE
    month_date = '2025-07';

BEGIN

--曜日をつけた
CREATE TEMP TABLE temp_work_records AS
SELECT
    work_id,
    employee_id,
    work_date,
    CASE EXTRACT(DOW FROM work_date)
        WHEN 0 THEN '日'
        WHEN 1 THEN '月'
        WHEN 2 THEN '火'
        WHEN 3 THEN '水'
        WHEN 4 THEN '木'
        WHEN 5 THEN '金'
        WHEN 6 THEN '土'
    END AS work_day
FROM
    work_records;

SELECT
	COUNT(*) AS weekday_count,
FROM
    temp_work_records
JOIN temp_work_records AS twr
    ON e.employee_id = twr.employee_id;

END;
$$ LANGUAGE plpgsql
