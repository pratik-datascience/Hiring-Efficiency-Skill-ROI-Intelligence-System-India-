-- Employee + company mapping
SELECT e.emp_id, c.company_name, e.role, e.salary
FROM employees e
JOIN companies c ON e.company_id = c.company_id;

-- Skill distribution per employee
SELECT e.emp_id, COUNT(es.skill_id) AS total_skills
FROM employees e
JOIN employee_skills es ON e.emp_id = es.emp_id
GROUP BY e.emp_id;

-- Average performance by company
SELECT c.company_name, AVG(p.rating) AS avg_rating
FROM companies c
JOIN employees e ON c.company_id = e.company_id
JOIN performance p ON e.emp_id = p.emp_id
GROUP BY c.company_name;