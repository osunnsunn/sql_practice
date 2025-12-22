WITH RECURSIVE tmp_monthly_date AS
SELECT 
    work_id,
    employee_id,
    work_date,
    (ARRAY['日','月','火','水','木','金','土'])[EXTRACT(DOW FROM work_date)]
FORM work_records;