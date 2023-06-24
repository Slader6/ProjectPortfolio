# Number of Manager per departments
SELECT
	d.dept_name,
    ee.gender,
	m.emp_no,
    m.from_date,
    m.to_date,
    e.calendar_year,
    CASE
		WHEN YEAR(m.to_date) >= e.calendar_year AND YEAR (m.from_date) <= e.calendar_year THEN '1'
        ELSE '0'
	END AS active
FROM
	(SELECT
		YEAR(hire_date) AS calendar_year
	FROM
		t_employees
	GROUP BY calendar_year) e
		CROSS JOIN
	t_dept_manager m
		JOIN
	t_employees ee ON ee.emp_no = m.emp_no
		JOIN
	t_departments d ON d.dept_no = m.dept_no
ORDER BY m.emp_no, calendar_year;