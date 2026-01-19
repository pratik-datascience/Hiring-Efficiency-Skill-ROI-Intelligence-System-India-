-- KPI 1: Skill ROI Score

-- How much performance do we get per salary unit?

SELECT 
    s.skill_name,
    ROUND(
        AVG(
            CAST(p.rating AS DECIMAL(10,4)) 
            / NULLIF(e.salary, 0)
        ) * 100000, 
    2) AS skill_roi_score
FROM skills s
JOIN employee_skills es ON s.skill_id = es.skill_id
JOIN employees e ON es.emp_id = e.emp_id
JOIN performance p ON e.emp_id = p.emp_id
GROUP BY s.skill_name
ORDER BY skill_roi_score DESC;

-------------------------------------------------------------------------------------------------------------

-- KPI 2: Hiring Efficiency Index
SELECT 
    c.company_name,
    ROUND(
        AVG(
            CAST(p.rating AS DECIMAL(10,4)) 
            / NULLIF(e.salary, 0)
        ) * 100000,
    2) AS hiring_efficiency
FROM companies c
JOIN employees e ON c.company_id = e.company_id
JOIN performance p ON e.emp_id = p.emp_id
GROUP BY c.company_name
ORDER BY hiring_efficiency DESC;




-- Performance Delivered per ₹1 Lakh Salary
SELECT 
    c.company_name,
    ROUND(
        AVG(p.rating * 100000.0 / e.salary),
    2) AS performance_per_1L_salary
FROM companies c
JOIN employees e ON c.company_id = e.company_id
JOIN performance p ON e.emp_id = p.emp_id
GROUP BY c.company_name
ORDER BY performance_per_1L_salary DESC;


-------------------------------------------------------------------------------------------------------------


-- KPI 3: Skill Density Impact
SELECT 
    skill_count,
    ROUND(AVG(rating),2) AS avg_rating
FROM (
    SELECT e.emp_id, COUNT(es.skill_id) AS skill_count, p.rating
    FROM employees e
    JOIN employee_skills es ON e.emp_id = es.emp_id
    JOIN performance p ON e.emp_id = p.emp_id
    GROUP BY e.emp_id, p.rating
) t
GROUP BY skill_count
ORDER BY skill_count;

-- More Insightful with one skill with each employee in data
WITH skill_profile AS (
    SELECT 
        e.emp_id,
        COUNT(es.skill_id) AS skill_count,
        p.rating
    FROM employees e
    LEFT JOIN employee_skills es ON e.emp_id = es.emp_id
    LEFT JOIN performance p ON e.emp_id = p.emp_id
    GROUP BY e.emp_id, p.rating
)
SELECT 
    skill_count,
    COUNT(*) AS employee_count,
    ROUND(AVG(rating), 2) AS avg_rating
FROM skill_profile
GROUP BY skill_count
ORDER BY skill_count;


-------------------------------------------------------------------------------------------------------------