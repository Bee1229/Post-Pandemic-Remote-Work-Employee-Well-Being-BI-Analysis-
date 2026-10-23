--TOTAL SURVEY RESPONSE 
SELECT COUNT(*)
FROM analytics.fact_employee_wellbeing;

--WORK HOURS AND WORK-LIFE BALANCE COMPARED TO BURNOUT LEVELS
CREATE VIEW HOURS_WORKED_WORK_LIFE_BALANCE_TO_BURNOUT_LEVELS AS (
SELECT 
    burnout_level,
    ROUND(AVG(hours_per_week),2) AS avg_hours_per_week,
    ROUND(AVG(work_life_balance_score),2) AS avg_work_life_balance_score
FROM analytics.fact_employee_wellbeing
GROUP BY burnout_level
ORDER BY avg_hours_per_week DESC);

--WORK HOURS AND WORK-LIFE BALANCE COMPARED TO INDUSTRIES
CREATE VIEW HOURS_WORKED_WORK_LIFE_BALANCE_TO_INDUSTIRIES AS (
SELECT 
    i.industry,
    ROUND(AVG(f.hours_per_week),2) AS avg_hours_per_week,
    ROUND(AVG(f.work_life_balance_score),2) AS avg_work_life_balance_score
FROM analytics.fact_employee_wellbeing f
JOIN analytics.dim_industry i 
    ON f.industry_key = i.industry_key
GROUP BY i.industry
ORDER BY avg_hours_per_week);

--SOCIAL ISOLATION AND WORK-LIFE BALANCE COMPARED TO WORK ARRANGEMENTS 
CREATE VIEW SOCIAL_ISOLATION_WORK_LIFE_BALANCE_TO_WORK_ARRANGEMENTS AS (
SELECT 
    w.work_arrangement,
    ROUND(AVG(f.social_isolation_score), 2) AS avg_social_isolation_score,
    ROUND(AVG(f.work_life_balance_score), 2) AS avg_work_life_balance_score
FROM analytics.fact_employee_wellbeing f
JOIN analytics.dim_work_arrangement w 
    ON f.work_arrangement_key = w.work_arrangement_key
GROUP BY w.work_arrangement
ORDER BY avg_social_isolation_score);

--HIGH RISK EMPLOYEES (HIGH BURNOUT LEVEL, MORE THAN 1 PHYSICAL HEALTH CHALLENGE AND LOW WORK-LIFE BALANCE)
CREATE VIEW HIGH_RISK_EMPLOYEES AS (
SELECT
    person_id,
    COUNT(DISTINCT physical_health_issue) AS no_of_physical_health_issues,
    burnout_level,
    work_life_balance_score
FROM analytics.fact_employee_wellbeing
WHERE burnout_level = 'High'
  AND work_life_balance_score IN (1, 2)
GROUP BY person_id, burnout_level, work_life_balance_score
HAVING COUNT(DISTINCT physical_health_issue) > 1
ORDER BY no_of_physical_health_issues DESC);

--HIGH BURNOUT LEVEL COMPARED TO THE GENDER
CREATE VIEW HIGH_BURNOUT_TO_GENDER AS (
SELECT
    e.gender,
    COUNT(DISTINCT f.person_id) AS employee_id,
    COUNT(DISTINCT CASE WHEN burnout_level = 'High' THEN f.person_id END) AS no_of_burnouts
FROM analytics.fact_employee_wellbeing f
LEFT JOIN dim_employee e 
    ON f.person_id = e.person_id
GROUP BY e.gender
ORDER BY no_of_burnouts DESC);

--HIGH BURNOUT LEVEL COMPARED TO AGE RANGE
CREATE VIEW HIGH_BURNOUT_HOURS_AND_AGE_RANGE AS (
SELECT
    e.age_range,
    COUNT(DISTINCT f.person_id) AS employee_id,
    COUNT(DISTINCT CASE WHEN burnout_level = 'High' THEN f.person_id END) AS no_of_burnouts
FROM analytics.fact_employee_wellbeing f
LEFT JOIN dim_employee e 
    ON f.person_id = e.person_id
GROUP BY e.age_range
ORDER BY no_of_burnouts DESC);

--HIGH BURNOUT LEVEL COMPARED TO THE HOURS WORKED AND THE SALARY LEVEL
CREATE VIEW HIGH_BURNOUT_HOURS_WORKED_AND_SALARY_LEVEL AS (
SELECT
    e.salary_range,
    COUNT(DISTINCT f.person_id) AS employee_id,
    COUNT(hours_per_week) AS no_of_hours_worked,
    COUNT(DISTINCT CASE WHEN burnout_level = 'High' THEN f.person_id END) AS no_of_burnouts
FROM analytics.fact_employee_wellbeing f
LEFT JOIN dim_employee e 
    ON f.person_id = e.person_id
GROUP BY e.salary_range
ORDER BY no_of_burnouts DESC);

--HIGH BURNOUT LEVEL COMPARED TO THE REGION 
CREATE VIEW HIGH_BURNOUT_IN_REGION AS ( 
SELECT
    r.region,
    COUNT(DISTINCT f.person_id) AS employee_id,
    COUNT(DISTINCT CASE WHEN burnout_level = 'High' THEN f.person_id END) AS no_of_burnouts
FROM analytics.fact_employee_wellbeing f
LEFT JOIN dim_region r 
    ON f.region_key = r.region_key
GROUP BY r.region
ORDER BY no_of_burnouts DESC);