-- 1️ Rank Employees by Salary Within Company
SELECT
    emp_id,
    company_id,
    role,
    salary,
    RANK() OVER (
        PARTITION BY company_id
        ORDER BY salary DESC
    ) AS salary_rank
FROM employees;


--2️ Identify Overpaid vs Underpaid Employees
SELECT
    emp_id,
    salary,
    AVG(salary) OVER (PARTITION BY company_id) AS company_avg_salary,
    salary - AVG(salary) OVER (PARTITION BY company_id) AS salary_gap
FROM employees;


--3️ Performance Percentile (Who are top performers?)
SELECT
    emp_id,
    rating,
    NTILE(4) OVER (ORDER BY rating DESC) AS performance_quartile
FROM performance;



--4️ Skill Count vs Performance Trend

SELECT
    es.emp_id,
    COUNT(es.skill_id) OVER (PARTITION BY es.emp_id) AS skill_count,
    p.rating
FROM employee_skills es
JOIN performance p 
    ON es.emp_id = p.emp_id;


-- 5️ City-Level Talent Ranking

WITH city_roi_cte AS (
    SELECT
        city,
        AVG(
            CAST(p.rating AS DECIMAL(10,4)) 
            / NULLIF(e.salary, 0)
        ) * 100000 AS city_roi
    FROM employees e
    JOIN performance p ON e.emp_id = p.emp_id
    GROUP BY city
)
SELECT
    city,
    ROUND(city_roi, 2) AS city_roi,
    DENSE_RANK() OVER (ORDER BY city_roi DESC) AS city_rank
FROM city_roi_cte
ORDER BY city_rank;


-- SUBQUERY VERSION

SELECT
    city,
    ROUND(city_roi, 2) AS city_roi,
    DENSE_RANK() OVER (ORDER BY city_roi DESC) AS city_rank
FROM (
    SELECT
        city,
        AVG(
            CAST(p.rating AS DECIMAL(10,4)) 
            / NULLIF(e.salary, 0)
        ) * 100000 AS city_roi
    FROM employees e
    JOIN performance p ON e.emp_id = p.emp_id
    GROUP BY city
) t
ORDER BY city_rank;



