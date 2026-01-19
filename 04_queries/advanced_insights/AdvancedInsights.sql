-- Overpaid Low Performers (Pain Point for Companies)
SELECT 
    e.emp_id,
    e.salary,
    p.rating
FROM employees e
JOIN performance p ON e.emp_id = p.emp_id
WHERE e.salary > (
    SELECT AVG(salary) FROM employees
)
AND p.rating < 3.0;

-------------------------------------------------------------------------------------------------------------

-- City Talent ROI

SELECT 
    city,
    ROUND(
        AVG(
            CAST(p.rating AS DECIMAL(10,4)) 
            / NULLIF(e.salary, 0)
        ) * 100000,
    2) AS city_roi
FROM employees e
JOIN performance p ON e.emp_id = p.emp_id
GROUP BY city
ORDER BY city_roi DESC;

-- Performance per ₹1 Lakh Salary by City
SELECT 
    city,
    ROUND(
        AVG(p.rating * 100000.0 / e.salary),
    2) AS performance_per_1L_salary
FROM employees e
JOIN performance p ON e.emp_id = p.emp_id
GROUP BY city
ORDER BY performance_per_1L_salary DESC;

-------------------------------------------------------------------------------------------------------------

-- Skills That Create High Performers
SELECT 
    s.skill_name,
    COUNT(*) AS high_performer_count
FROM skills s
JOIN employee_skills es ON s.skill_id = es.skill_id
JOIN performance p ON es.emp_id = p.emp_id
WHERE p.rating >= 4.5
GROUP BY s.skill_name
ORDER BY high_performer_count DESC;
