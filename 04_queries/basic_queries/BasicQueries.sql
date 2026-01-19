-- Total employees
SELECT COUNT(*) AS total_employees FROM employees;

-- Average salary by role
SELECT role, AVG(salary) AS avg_salary
FROM employees
GROUP BY role;

-- Active employees (not exited)
SELECT COUNT(*) AS active_employees
FROM employees
WHERE exit_date IS NULL;
