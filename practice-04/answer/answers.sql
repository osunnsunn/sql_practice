CREATE OR REPLACE PROCEDURE calculate_monthly_salary_summary(
    target_year_month CHAR(7)
)
LANGUAGE plpgsql
AS $$
DECLARE

BEGIN

--メモ：一時テーブルに全部の情報入れた
CREATE TEMP TABLE temp_work_records AS
SELECT
    wr.work_id,
    wr.employee_id,
    wr.work_date,
	wr.hours_worked,
	CASE
	    WHEN wr.employee_id = e.employee_id THEN hourly_wage
		ELSE 000
	END AS wage,
	CASE
	    WHEN wr.shift_type = 'night' THEN e.night_shift_rate --夜勤
	    WHEN wr.work_date = h.holiday_date THEN e.holiday_rate --休日
		ELSE 1.00 --平日
	END AS rate
FROM work_records AS wr
JOIN employees AS e ON e.employee_id = wr.employee_id
LEFT JOIN holidays AS h ON h.holiday_date = wr.work_date
WHERE wr.work_date BETWEEN '2025-07-01' AND '2025-07-31';

OPEN summary_cursor;
CLOSE summary_cursor

END;
$$