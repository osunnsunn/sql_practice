CREATE OR REPLACE PROCEDURE calculate_monthly_salary_summary(
    target_year_month CHAR(7)
)
LANGUAGE plpgsql
AS $$
DECLARE
    rec RECORD;
	total_salary_1 INT = 0;
	total_salary_2 INT = 0;
	total_salary_3 INT = 0;

	cur CURSOR FOR
        SELECT
		    work_id,
			employee_id,
			name,
			work_date,
			hours_worked,
			wage,
			rate
        FROM temp_work_records AS twr;
BEGIN

    DROP TABLE IF EXISTS temp_work_records;
	CREATE TEMP TABLE temp_work_records AS
	SELECT
	    wr.work_id,
		wr.employee_id,
		e.name,
		wr.work_date,
		wr.hours_worked,
		CASE
		    WHEN wr.employee_id = e.employee_id THEN hourly_wage
			ELSE NULL
		END AS wage,
		CASE
		    WHEN wr.shift_type = 'night' THEN e.night_shift_rate --夜勤
			WHEN EXTRACT(DOW FROM wr.work_date) IN (0,6) THEN e.holiday_rate --休日
			WHEN wr.work_date = h.holiday_date THEN e.holiday_rate --休日
			ELSE 1.00 --平日
		END AS rate
	FROM work_records AS wr
	JOIN employees AS e ON e.employee_id = wr.employee_id
	LEFT JOIN holidays AS h ON h.holiday_date = wr.work_date
	WHERE wr.work_date BETWEEN '2025-07-01' AND '2025-07-31'
	ORDER BY wr.employee_id ASC, wr.work_date;
	
	OPEN cur;
	    LOOP
		    FETCH cur INTO rec;
			EXIT WHEN NOT FOUND;
		
		CASE rec.employee_id
		    WHEN '1' THEN
			    RAISE NOTICE '日付：% / 従業員：% / 時給：% / 割増：% / 作業時間：% '
				, rec.work_date, rec.name, rec.wage, rec.rate, rec.hours_worked;
				total_salary_1 = total_salary_1 + rec.wage * rec.rate * rec.hours_worked;
				RAISE NOTICE '合計:%',total_salary_1;
			WHEN '2' THEN
			    RAISE NOTICE '日付：% / 従業員：% / 時給：% / 割増：% / 作業時間：% '
				, rec.work_date, rec.name, rec.wage, rec.rate, rec.hours_worked;
				total_salary_2 = total_salary_2 + rec.wage * rec.rate * rec.hours_worked;
				RAISE NOTICE '合計:%',total_salary_2;
			WHEN '3' THEN
			    RAISE NOTICE '日付：% / 従業員：% / 時給：% / 割増：% / 作業時間：% '
				, rec.work_date, rec.name, rec.wage, rec.rate, rec.hours_worked;
				total_salary_3 = total_salary_3 + rec.wage * rec.rate * rec.hours_worked;
				RAISE NOTICE '合計:%',total_salary_3;
			ELSE NULL;
		END CASE;
	END LOOP;
	
	RAISE NOTICE '%', total_salary_1;
	RAISE NOTICE '%', total_salary_2;
	RAISE NOTICE '%', total_salary_3;
	
	INSERT INTO monthly_salary_summary (
	    employee_id,
		year_month,
		total_salary
	)
	VALUES (
	    1,
		target_year_month,
		total_salary_1
	)
	ON CONFLICT (employee_id, year_month)
	DO UPDATE SET
    total_salary = EXCLUDED.total_salary;

	INSERT INTO monthly_salary_summary (
	    employee_id,
		year_month,
		total_salary
	)
	VALUES (
	    2,
		target_year_month,
		total_salary_2
	)
	ON CONFLICT (employee_id, year_month)
	DO UPDATE SET
    total_salary = EXCLUDED.total_salary;

	INSERT INTO monthly_salary_summary (
	    employee_id,
		year_month,
		total_salary
	)
	VALUES (
	    3,
		target_year_month,
		total_salary_3
	)
	ON CONFLICT (employee_id, year_month)
	DO UPDATE SET
    total_salary = EXCLUDED.total_salary;

CLOSE cur;
END $$;