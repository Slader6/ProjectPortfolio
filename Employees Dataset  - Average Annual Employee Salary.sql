# Average Annual Employee Salary
SELECT 
    e.gender,
    d.dept_name,
    ROUND(AVG(s.salary), 2) AS salary,
    YEAR(s.from_date) AS calendar_year
FROM
    t_employees e
        JOIN
    t_dept_emp de ON de.emp_no = e.emp_no
        JOIN
    t_salaries s ON s.emp_no = e.emp_no
        JOIN
    t_departments d ON d.dept_no = de.dept_no
GROUP BY d.dept_no , e.gender , calendar_year
HAVING calendar_year <= 2002
ORDER BY d.dept_no
LIMIT 1000;
