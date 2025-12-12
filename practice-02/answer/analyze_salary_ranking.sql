CREATE OR REPLACE VIEW employee_salary_analysis  AS
WITH salary_info AS ( --共通テーブル式CTE
    SELECT department_id, AVG(salary)::INT AS department_avg_salary
		FROM employees
	GROUP BY department_id
)
SELECT
    d.name AS department_name,
    e.name AS employees_name,
    e.salary AS employees_salary,
    s.department_avg_salary,
	RANK() OVER (PARTITION BY e.department_id ORDER BY e.salary DESC)::INT AS salary_rank_in_department
FROM employees AS e
JOIN departments AS d ON e.department_id = d.id
JOIN salary_info AS s ON e.department_id = s.department_id
ORDER BY d.name, e.salary DESC;