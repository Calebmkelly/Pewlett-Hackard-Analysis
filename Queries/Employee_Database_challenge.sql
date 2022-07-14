
-- Deliverable 1 --
SELECT DISTINCT ON (emp_no) rt.emp_no,
    rt.first_name,
    rt.last_name,
rt.title
INTO unique_titles
FROM retirement_titles as rt
    WHERE (to_date = '9999-01-01')
ORDER BY emp_no ASC, to_date DESC;

-- Get the count for each title 
SELECT COUNT (ut.title), ut.title
INTO retiring_titles
FROM unique_titles as ut
GROUP BY title 
ORDER BY count DESC;

-- Deliverable 2 --
SELECT DISTINCT ON (emp_no) 
    e.emp_no,
    e.first_name,
    e.last_name,
    e.birth_date,
    de.from_date,
    de.to_date,
    ts.title
INTO mentorship_eligibility
FROM employees as e
    INNER JOIN dept_employee as de
        ON (e.emp_no = de.emp_no)
    INNER JOIN titles as ts
        ON (e.emp_no = ts.emp_no)
WHERE (birth_date BETWEEN '1965-01-01' AND '1965-12-31')
    AND (ts.to_date = '9999-01-01')
ORDER BY emp_no;
