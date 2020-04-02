-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.

--Create 6 tables
CREATE TABLE departments (
    dept_no VARCHAR   NOT NULL,
    dept_name VARCHAR   NOT NULL,
    CONSTRAINT pk_departments PRIMARY KEY (
        dept_no
     )
);

CREATE TABLE dept_emp (
    emp_no INT   NOT NULL,
    dept_no VARCHAR   NOT NULL,
    from_date DATE   NOT NULL,
    to_date DATE   NOT NULL
);

CREATE TABLE dept_manager (
    dept_no VARCHAR   NOT NULL,
    emp_no INT   NOT NULL,
    from_date DATE   NOT NULL,
    to_date DATE   NOT NULL
);

CREATE TABLE employees (
    emp_no INT   NOT NULL,
    birth_date DATE   NOT NULL,
    first_name VARCHAR   NOT NULL,
    last_name VARCHAR   NOT NULL,
    gender VARCHAR   NOT NULL,
    hire_date DATE   NOT NULL,
    CONSTRAINT pk_employees PRIMARY KEY (
        emp_no
     )
);

CREATE TABLE salaries (
    emp_no INT   NOT NULL,
    salary INT   NOT NULL,
    from_date DATE   NOT NULL,
    to_date DATE   NOT NULL
);

CREATE TABLE titles (
    emp_no INT   NOT NULL,
    title VARCHAR   NOT NULL,
    from_date DATE   NOT NULL,
    to_date DATE   NOT NULL
);

--Constraints/foreign keys
ALTER TABLE dept_emp ADD CONSTRAINT fk_dept_emp_emp_no FOREIGN KEY(emp_no)
REFERENCES employees (emp_no);

ALTER TABLE dept_emp ADD CONSTRAINT fk_dept_emp_dept_no FOREIGN KEY(dept_no)
REFERENCES departments (dept_no);

ALTER TABLE dept_manager ADD CONSTRAINT fk_dept_manager_dept_no FOREIGN KEY(dept_no)
REFERENCES departments (dept_no);

ALTER TABLE dept_manager ADD CONSTRAINT fk_dept_manager_emp_no FOREIGN KEY(emp_no)
REFERENCES employees (emp_no);

ALTER TABLE salaries ADD CONSTRAINT fk_salaries_emp_no FOREIGN KEY(emp_no)
REFERENCES employees (emp_no);

ALTER TABLE titles ADD CONSTRAINT fk_titles_emp_no FOREIGN KEY(emp_no)
REFERENCES employees (emp_no);

--List employee info
CREATE VIEW employee_info AS
SELECT employees.emp_no, employees.last_name, employees.first_name, employees.gender, salaries.salary
FROM employees
INNER JOIN salaries ON
employees.emp_no = salaries.emp_no;


--List employees hired in 1986
CREATE VIEW eightysix_emp AS
SELECT emp_no, last_name, first_name, hire_date
FROM employees
WHERE hire_date >= '1/01/1986'::date
AND hire_date <= '12/31/1986'::date

SELECT *
FROM eightysix_emp;

--List the manager of each dept
CREATE VIEW managers
SELECT dept_manager.dept_no, dept_manager.emp_no, departments.dept_name, employees.last_name, employees.first_name, salaries.from_date, salaries.to_date
FROM dept_manager
JOIN departments
ON (dept_manager.dept_no = departments.dept_no)
JOIN employees
ON (employees.emp_no = dept_manager.emp_no)
JOIN salaries
ON (employees.emp_no = salaries.emp_no)

SELECT *
FROM managers;

--employee list with department
CREATE VIEW emp_depts AS
SELECT departments.dept_name, employees.emp_no, employees.last_name, employees.first_name
FROM employees
JOIN dept_emp
ON (employees.emp_no = dept_emp.emp_no)
JOIN departments
ON (dept_emp.dept_no = departments.dept_no)

SELECT *
FROM emp_depts;

--List all employees with first name Hercules, last name starting with B
SELECT first_name, last_name
FROM employees
WHERE first_name = 'Hercules'
AND last_name LIKE 'B%';

--List all employees in sales department
CREATE VIEW sales_dept AS
SELECT dept_emp.emp_no, employees.last_name, employees.first_name, departments.dept_name
FROM dept_emp
JOIN employees
ON (employees.emp_no = dept_emp.emp_no)
JOIN departments
ON (departments.dept_no = dept_emp.dept_no);

SELECT *
FROM sales_dept
WHERE dept_name = 'Sales';

--List sales and development employees
CREATE VIEW sales_dev_dept AS
SELECT dept_emp.emp_no, employees.last_name, employees.first_name, departments.dept_name
FROM dept_emp
JOIN employees
ON (employees.emp_no = dept_emp.emp_no)
JOIN departments
ON (departments.dept_no = dept_emp.dept_no);

SELECT *
FROM sales_dev_dept
WHERE dept_name = 'Sales'
OR dept_name = 'Development';

--list the frequency count of employee last names in descending order
SELECT
   last_name,
   COUNT (last_name)
FROM
   employees
GROUP BY
   last_name
ORDER BY "last_name" DESC;
