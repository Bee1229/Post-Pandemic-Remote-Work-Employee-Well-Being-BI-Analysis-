--DIM_DATE
DROP TABLE IF EXISTS dim_date;
CREATE TABLE analytics.dim_date(
    date_key INTEGER PRIMARY KEY,
    full_date DATE NOT NULL,
    year INTEGER,
    month INTEGER,
    quarter INTEGER,
    month_name VARCHAR(20)
);

INSERT INTO analytics.dim_date(
    date_key,
    full_date,
    year,
    month,
    quarter,
    month_name
)
SELECT DISTINCT
    TO_CHAR(survey_date, 'YYYYMMDD')::INTEGER AS date_key,
    survey_date AS full_date,
    EXTRACT(YEAR FROM survey_date)::INTEGER AS year,
    EXTRACT(MONTH FROM survey_date)::INTEGER AS month,
    EXTRACT(QUARTER FROM survey_date)::INTEGER AS quarter,
    MONTHNAME(survey_date) AS month_name
FROM staging.stg_employee_wellbeing;

--DIM_WORK_ARRANGEMENT
DROP TABLE IF EXISTS analytics.dim_work_arrangement;
CREATE TABLE analytics.dim_work_arrangement(
    work_arrangement_key INTEGER PRIMARY KEY,
    work_arrangement VARCHAR
);

INSERT INTO analytics.dim_work_arrangement(
    work_arrangement_key,
    work_arrangement
)
SELECT
    ROW_NUMBER() OVER(ORDER BY work_arrangement) AS work_arrangement_key,
    work_arrangement
FROM staging.stg_employee_wellbeing
GROUP BY work_arrangement;

--DIM_INDUSTRY
DROP TABLE IF EXISTS analytics.dim_industry;
CREATE TABLE analytics.dim_industry(
    industry_key INTEGER PRIMARY KEY,
    industry VARCHAR
);
INSERT INTO analytics.dim_industry(
    industry_key,
    industry
)
SELECT
    ROW_NUMBER() OVER(ORDER BY industry) AS industry_key,
    industry
FROM staging.stg_employee_wellbeing
GROUP BY industry;

--DIM_REGION
DROP TABLE IF EXISTS analytics.dim_region;
CREATE TABLE analytics.dim_region(
    region_key INTEGER PRIMARY KEY,
    region VARCHAR
);
INSERT INTO analytics.dim_region(
    region_key,
    region
)
SELECT 
    ROW_NUMBER() OVER(ORDER BY region) AS region_key,
    region
FROM staging.stg_employee_wellbeing
GROUP BY region

--DIM_JOBS
DROP TABLE IF EXISTS analytics.dim_jobs;
CREATE TABLE analytics.dim_jobs(
    job_key INTEGER PRIMARY KEY,
    job_role VARCHAR
);
INSERT INTO analytics.dim_jobs(
    job_key,
    job_role
)
SELECT 
    ROW_NUMBER() OVER(ORDER BY job_role) AS job_key,
    job_role
FROM staging.stg_employee_wellbeing
GROUP BY job_role

--DIM_MENTAL_HEALTH_STATUS
DROP TABLE IF EXISTS analytics.dim_mental_health_status;
CREATE TABLE analytics.dim_mental_health_status(
    mental_health_key INTEGER PRIMARY KEY,
    mental_health_status VARCHAR
);
INSERT INTO analytics.dim_mental_health_status(
    mental_health_key,
    mental_health_status
)
SELECT 
    ROW_NUMBER() OVER(ORDER BY mental_health_status) AS mental_health_key,
    mental_health_status
FROM staging.stg_employee_wellbeing
GROUP BY mental_health_status;


--DIM_EMPLOYEE
DROP TABLE IF EXISTS analytics.dim_employee;
CREATE TABLE analytics.dim_employee(
    person_id INTEGER PRIMARY KEY,
    age INTEGER,
    gender VARCHAR,
    age_range VARCHAR,
    salary_range VARCHAR
);
INSERT INTO analytics.dim_employee(
    person_id,
    age,
    gender,
    age_range,
    salary_range
)
SELECT
    ROW_NUMBER() OVER(ORDER BY person_id) AS person_id,
    age,
    gender,
    age_range,
    salary_range
FROM staging.stg_employee_wellbeing
GROUP BY person_id,2,3,4,5;


select *
from analytics.dim_employee
select *
FROM staging.stg_employee_wellbeing