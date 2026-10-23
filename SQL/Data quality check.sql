--AGE (lowest is 20 and highest is 70)
SELECT *
FROM staging.stg_employee_wellbeing
WHERE age < 20 
    OR age > 70;

--WORKING HOURS (lowest 24 and highest 70)
SELECT *
FROM staging.stg_employee_wellbeing
WHERE hours_per_week < 24 
    OR hours_per_week > 70;

--WORK-LIFE BALANCE (1-5)
SELECT *
FROM staging.stg_employee_wellbeing
WHERE work_life_balance_score < 1 
    OR work_life_balance_score > 5;

--SOCIAL ISOLATION (1-5)
SELECT *
FROM staging.stg_employee_wellbeing
WHERE social_isolation_score < 1 
    OR social_isolation_score > 5;

--WORK ARRANGEMENTS (Only Onsite. Hybrid and Remote)
SELECT DISTINCT(work_arrangement)
FROM staging.stg_employee_wellbeing;