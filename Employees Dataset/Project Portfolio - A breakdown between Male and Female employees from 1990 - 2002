# A breakdown between Male and Female employees from 1990 - 2002
SELECT 
    YEAR(d.from_date) AS calendar_year,
    e.gender AS gender,
    COUNT(e.emp_no) AS num_of_employees
FROM
    t_employees e	
        JOIN
    t_dept_emp d ON d.emp_no = e.emp_no	
GROUP BY calendar_year , gender
HAVING calendar_year >= 1990;
