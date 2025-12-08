CREATE OR REPLACE VIEW analyze_salary_ranking  AS
WITH salary_info AS ( --共通テーブル式CTE
    SELECT
        e.id AS employee_id,
        e.name AS employee_name,
        e.salary,
        e.department_id,
        RANK() OVER (PARTITION BY e.department_id ORDER BY e.salary DESC) AS rank_in_department, --部署の給料高い順
        AVG(e.salary) OVER (PARTITION BY e.department_id) AS avg_salary --部署の平均給料
    FROM employees e
)
SELECT
    d.name AS department_name,
    s.employee_name,
    s.salary,
    ROUND(s.avg_salary)::INT AS department_avg_salary, --平均給与を四捨五入
    s.rank_in_department::INT AS salary_rank_in_department --部署の給料高い順2
FROM salary_info s
JOIN departments d 
  ON s.department_id = d.id
ORDER BY d.name, s.rank_in_department;