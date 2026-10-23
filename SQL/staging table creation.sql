DROP TABLE staging.stg_employee_wellbeing;
CREATE TABLE staging.stg_employee_wellbeing (
    person_id INTEGER PRIMARY KEY,
    survey_date DATE,
    age INTEGER,
    gender VARCHAR(50),
    region VARCHAR(100),
    industry VARCHAR(100),
    job_role VARCHAR(100),
    work_arrangement VARCHAR(50),
    hours_per_week INTEGER,
    mental_health_status VARCHAR(100),
    burnout_level VARCHAR(50),
    work_life_balance_score INTEGER,
    physical_health_issues VARCHAR(100),
    social_isolation_score INTEGER,
    salary_range VARCHAR(50),
    age_range VARCHAR(50)
);

INSERT INTO staging.stg_employee_wellbeing(
    person_id,
    survey_date,
    age,
    gender,
    region,
    industry,
    job_role,
    work_arrangement,
    hours_per_week,
    mental_health_status,
    burnout_level,
    work_life_balance_score,
    physical_health_issues,
    social_isolation_score,
    salary_range,
    age_range
)
SELECT 
    person_id,
    survey_date::DATE,
    age,
    gender,
    region,
    industry,
    job_role,
    CASE
        WHEN work_arrangement = 'Onsite'
        THEN work_arrangement
        WHEN work_arrangement = 'Hybrid'
        THEN work_arrangement
        WHEN work_arrangement = 'Remote'
        THEN work_arrangement
        ELSE 'None'
    END,
    hours_per_week,
    mental_health_status,
    burnout_level,
    CASE 
        WHEN work_life_balance_score BETWEEN 1 AND 5
        THEN work_life_balance_score
        ELSE NULL
    END,
    physical_health_issues,
    CASE
        WHEN social_isolation_score BETWEEN 1 AND 5
        THEN social_isolation_score
        ELSE NULL
    END,
    salary_range,
    age_range
FROM raw.post_pandemic_health;


SELECT *
FROM staging.stg_employee_wellbeing

