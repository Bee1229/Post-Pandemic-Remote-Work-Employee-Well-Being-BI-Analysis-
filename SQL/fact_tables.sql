DROP TABLE IF EXISTS analytics.fact_employee_wellbeing;
CREATE TABLE analytics.fact_employee_wellbeing(
    person_id            INTEGER PRIMARY KEY REFERENCES dim_employee(person_id),
    industry_key         INTEGER NOT NULL REFERENCES dim_industry(industry_key),
    job_key             INTEGER NOT NULL REFERENCES dim_jobs(job_key),
    region_key               INTEGER NOT NULL REFERENCES dim_region(region_key),
    work_arrangement_key     INTEGER NOT NULL REFERENCES dim_work_arrangement(work_arrangement_key),
    date_key                 INTEGER NOT NULL REFERENCES dim_date(date_key),
    hours_per_week           INTEGER NOT NULL,
    work_life_balance_score  INTEGER NOT NULL CHECK (work_life_balance_score BETWEEN 1 AND 5),
    physical_health_issue    TEXT NOT NULL,
    social_isolation_score   INTEGER NOT NULL CHECK (social_isolation_score  BETWEEN 1 AND 5),
    mental_health_key    INTEGER NOT NULL REFERENCES dim_mental_health_status(mental_health_key),
    burnout_level            TEXT NOT NULL    
);

INSERT INTO analytics.fact_employee_wellbeing
SELECT
    e.person_id,
    o.industry_key,
    j.job_key,
    r.region_key,
    w.work_arrangement_key,
    d.date_key,
    hours_per_week,
    work_life_balance_score,
    physical_health_issues,
    social_isolation_score,
    m.mental_health_key,
    burnout_level 

FROM staging.stg_employee_wellbeing s
JOIN dim_employee         e ON e.person_id        = s.person_id
JOIN dim_industry     o ON o.industry         = s.industry
JOIN dim_jobs         j ON j.job_role         = s.job_role
JOIN dim_region           r ON r.region           = s.region
JOIN dim_work_arrangement w ON w.work_arrangement = s.work_arrangement
JOIN dim_date             d ON d.full_date = s.survey_date
JOIN dim_mental_health_status m ON m.mental_health_status = s.mental_health_status;

select *
FROM analytics.fact_employee_wellbeing

SELECT *
FROM staging.stg_employee_wellbeing