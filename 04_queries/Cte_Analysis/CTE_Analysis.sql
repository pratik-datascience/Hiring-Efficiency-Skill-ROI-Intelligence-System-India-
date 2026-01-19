
-- Skill ROI Efficiency Index

WITH emp_base AS (
    SELECT
        e.emp_id,
        e.salary,
        p.rating
    FROM employees e
    JOIN performance p ON e.emp_id = p.emp_id
),
emp_skill_count AS (
    SELECT
        emp_id,
        COUNT(*) AS skill_count
    FROM employee_skills
    GROUP BY emp_id
),
skill_base AS (
    SELECT
        s.skill_name,
        eb.rating,
        eb.salary * 1.0 / esc.skill_count AS salary_per_skill
    FROM employee_skills es
    JOIN skills s ON es.skill_id = s.skill_id
    JOIN emp_base eb ON es.emp_id = eb.emp_id
    JOIN emp_skill_count esc ON es.emp_id = esc.emp_id
)
SELECT TOP 20
    skill_name,
    ROUND(
        AVG(rating * 100000.0 / salary_per_skill),
        2
    ) AS performance_per_1L_salary
FROM skill_base
GROUP BY skill_name
ORDER BY performance_per_1L_salary DESC;




-- 2] Hiring Efficiency Index by Company
WITH company_perf AS (
    SELECT
        c.company_name,
        e.salary,
        p.rating
    FROM companies c
    JOIN employees e ON c.company_id = e.company_id
    JOIN performance p ON e.emp_id = p.emp_id
)
SELECT
    company_name,
    ROUND(AVG(rating * 1.0 / salary) * 100000, 2) AS hiring_efficiency
FROM company_perf
GROUP BY company_name
ORDER BY hiring_efficiency DESC;






-- 3] Overpaid Low Performers (CTE)

WITH avg_salary AS (
    SELECT AVG(salary) AS avg_sal FROM employees
)
SELECT
    e.emp_id,
    e.salary,
    p.rating
FROM employees e
JOIN performance p ON e.emp_id = p.emp_id
CROSS JOIN avg_salary
WHERE e.salary > avg_sal
AND p.rating < 3;






-- 4] Skill Density Impact on Performance
WITH skill_count AS (
    SELECT
        emp_id,
        COUNT(skill_id) AS total_skills
    FROM employee_skills
    GROUP BY emp_id
)
SELECT
    sc.total_skills,
    ROUND(AVG(p.rating),2) AS avg_rating
FROM skill_count sc
JOIN performance p ON sc.emp_id = p.emp_id
GROUP BY sc.total_skills
ORDER BY sc.total_skills;

-- 5]  Company Performance Deviation (CTE + Window)--  ADVANCED
WITH perf_base AS (
    SELECT
        e.emp_id,
        e.company_id,
        p.rating,
        AVG(p.rating) OVER (PARTITION BY e.company_id) AS company_avg
    FROM employees e
    JOIN performance p ON e.emp_id = p.emp_id
)
SELECT
    emp_id,
    rating,
    company_avg,
    rating - company_avg AS deviation
FROM perf_base;



-- 6] Attrition Risk Score (Window Logic)
SELECT
    e.emp_id,
    e.salary,
    p.rating,
    CASE
        WHEN p.rating < 3 
             AND e.salary < AVG(e.salary) OVER () 
        THEN 'High Risk'

        WHEN p.rating < 3 
        THEN 'Medium Risk'

        ELSE 'Low Risk'
    END AS attrition_risk
FROM employees e
JOIN performance p 
    ON e.emp_id = p.emp_id;
