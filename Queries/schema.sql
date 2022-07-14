-- Creating tables for PH_EmployeeDB
CREATE TABLE departments (
    dept_no VARCHAR(4) NOT NULL,
    dept_name VARCHAR(40) NOT NULL,
    PRIMARY KEY (dept_no),
        UNIQUE (dept_name)
);

CREATE TABLE employees (
    emp_no INT NOT NULL,
    birth_date DATE NOT NULL,
    first_name VARCHAR NOT NULL,
    last_name VARCHAR NOT NULL,
    gender VARCHAR NOT NULL,
    hire_date DATE NOT NULL,
    PRIMARY KEY (emp_no)
);

CREATE TABLE dept_manager (
    dept_no VARCHAR(4) NOT NULL,
    emp_no INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
    FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no, dept_no)
); 

CREATE TABLE salaries(
    emp_no INT NOT NULL,
    salary INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL, 
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
    PRIMARY KEY (emp_no)
);

CREATE TABLE dept_employee(
    dept_no VARCHAR(4) NOT NULL,
    emp_no INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
    FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (dept_no, emp_no)
);

CREATE TABLE titles (
    emp_no INT NOT NULL,
    title VARCHAR NOT NULL,
    from_date date NOT NULL,
    to_date date NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
    PRIMARY KEY (emp_no, from_date)
);

-- check if data matches with csv
SELECT * FROM departments;
SELECT * FROM dept_employee;
SELECT * FROM dept_manager;
SELECT * FROM employees;
SELECT * FROM salaries;
SELECT * FROM titles;


-- finding employees who will retire total, then by year.
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

--1952
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31'

--1953
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31'

--1954
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31'

--1955
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31'



-- Retirement eligibility
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Number of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- exporting the retirement elgible employees into a new table
SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT * FROM retirement_info;

DROP TABLE retirement_info;

-- Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT * FROM retirement_info;

--joining Departments and dept_manager tables
SELECT d.dept_name,
     dm.emp_no, 
     dm.from_date, 
     dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;

-- Joining retirement_info and dept_emp tables
SELECT retirement_info.emp_no,
    retirement_info.first_name,
    retirement_info.last_name,
    dept_employee.to_date
FROM retirement_info
LEFT JOIN dept_employee
ON retirement_info.emp_no = dept_employee.emp_no;

--practice shortening table names
SELECT ri.emp_no,
    ri.first_name,
    ri.last_name,
    de.to_date
FROM retirement_info as ri
LEFT JOIN dept_employee as de
ON ri.emp_no = de.emp_no;

--joining retirement_info and dept_emp tables
SELECT ri.emp_no,
    ri.first_name,
    ri.last_name,
de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_employee as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

SELECT * FROM current_emp;

-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
INTO dept_emp_count
FROM current_emp as ce
LEFT JOIN dept_employee as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

SELECT * FROM dept_emp_count;

SELECT * FROM salaries
ORDER BY to_date DESC;

--new reitirement info table with gender
SELECT emp_no, first_name, last_name, gender
INTO emp_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

DROP TABLE emp_info;

SELECT e.emp_no,
    e.first_name,
    e.last_name,
    e.gender,
    s.salary,
de.to_date
INTO emp_info
FROM employees as e
    INNER JOIN salaries as s
        ON (e.emp_no = s.emp_no)
    INNER JOIN dept_employee as de
        ON (e.emp_no = de.emp_no)
    WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
        AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31')
        AND (de.to_date = '9999-01-01');

SELECT * FROM emp_info;

-- List of managers per department
SELECT dm.dept_no,
    d.dept_name,
    dm.emp_no,
    ce.last_name,
    ce.first_name,
    dm.from_date,
dm.to_date
INTO manager_info
FROM dept_manager AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN current_emp AS ce
        ON (dm.emp_no = ce.emp_no);

SELECT * FROM manager_info;

-- table with employee info and dept name
SELECT ce.emp_no,
    ce.first_name,
    ce.last_name,
d.dept_name
INTO dept_info
FROM current_emp AS ce
    INNER JOIN dept_employee AS de
        ON (ce.emp_no = de.emp_no)
    INNER JOIN departments AS d
        ON (de.dept_no = d.dept_no);

-- table with employee info and dept name for sales
SELECT ce.emp_no,
    ce.first_name,
    ce.last_name,
d.dept_name
INTO sales_dept_info
FROM current_emp AS ce
    INNER JOIN dept_employee AS de
        ON (ce.emp_no = de.emp_no)
    INNER JOIN departments AS d
        ON (de.dept_no = d.dept_no)
    WHERE (dept_name = 'Sales')
    
-- table with employee info and dept name for sales and dev
SELECT ce.emp_no,
    ce.first_name,
    ce.last_name,
d.dept_name
INTO sales_dev_dept_info
FROM current_emp AS ce
    INNER JOIN dept_employee AS de
        ON (ce.emp_no = de.emp_no)
    INNER JOIN departments AS d
        ON (de.dept_no = d.dept_no)
    WHERE dept_name IN ('Sales', 'Development');
    
-- employees elgible for retirement with titles
SELECT e.emp_no,
    e.first_name,
    e.last_name,
    ts.title,
    ts.from_date,
ts.to_date
INTO retirement_titles
FROM employees AS e 
    INNER JOIN titles AS ts
        ON (e.emp_no = ts.emp_no)
    WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
    ORDER BY emp_no;

-- Use Dictinct with Orderby to remove duplicate rows
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