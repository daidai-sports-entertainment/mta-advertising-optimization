-- =====================================
-- FILE 2: 02_data_quality_checks.sql
-- Comprehensive data quality analysis
-- =====================================

-- 1. Checking for any null values across all tables
SELECT
    'raw_turnstile_2019' as table_name,
    COUNT(*) as total_rows,
    SUM(CASE WHEN c_a IS NULL THEN 1 ELSE 0 END) as c_a_null_count,
    SUM(CASE WHEN unit IS NULL THEN 1 ELSE 0 END) as unit_null_count,
    SUM(CASE WHEN scp IS NULL THEN 1 ELSE 0 END) as scp_null_count,
    SUM(CASE WHEN station IS NULL THEN 1 ELSE 0 END) as station_null_count,
    SUM(CASE WHEN line_name IS NULL THEN 1 ELSE 0 END) as line_name_null_count,
    SUM(CASE WHEN division IS NULL THEN 1 ELSE 0 END) as division_null_count,
    SUM(CASE WHEN audit_date IS NULL THEN 1 ELSE 0 END) as audit_date_null_count,
    SUM(CASE WHEN audit_time IS NULL THEN 1 ELSE 0 END) as audit_time_null_count,
    SUM(CASE WHEN description IS NULL THEN 1 ELSE 0 END) as description_null_count,
    SUM(CASE WHEN entries IS NULL THEN 1 ELSE 0 END) as entries_null_count,
    SUM(CASE WHEN exits IS NULL THEN 1 ELSE 0 END) as exits_null_count
FROM raw_turnstile_2019
UNION ALL
SELECT
    'raw_turnstile_2020' as table_name,
    COUNT(*) as total_rows,
    SUM(CASE WHEN c_a IS NULL THEN 1 ELSE 0 END) as c_a_null_count,
    SUM(CASE WHEN unit IS NULL THEN 1 ELSE 0 END) as unit_null_count,
    SUM(CASE WHEN scp IS NULL THEN 1 ELSE 0 END) as scp_null_count,
    SUM(CASE WHEN station IS NULL THEN 1 ELSE 0 END) as station_null_count,
    SUM(CASE WHEN line_name IS NULL THEN 1 ELSE 0 END) as line_name_null_count,
    SUM(CASE WHEN division IS NULL THEN 1 ELSE 0 END) as division_null_count,
    SUM(CASE WHEN audit_date IS NULL THEN 1 ELSE 0 END) as audit_date_null_count,
    SUM(CASE WHEN audit_time IS NULL THEN 1 ELSE 0 END) as audit_time_null_count,
    SUM(CASE WHEN description IS NULL THEN 1 ELSE 0 END) as description_null_count,
    SUM(CASE WHEN entries IS NULL THEN 1 ELSE 0 END) as entries_null_count,
    SUM(CASE WHEN exits IS NULL THEN 1 ELSE 0 END) as exits_null_count
FROM raw_turnstile_2020
UNION ALL
SELECT
    'raw_turnstile_2021' as table_name,
    COUNT(*) as total_rows,
    SUM(CASE WHEN c_a IS NULL THEN 1 ELSE 0 END) as c_a_null_count,
    SUM(CASE WHEN unit IS NULL THEN 1 ELSE 0 END) as unit_null_count,
    SUM(CASE WHEN scp IS NULL THEN 1 ELSE 0 END) as scp_null_count,
    SUM(CASE WHEN station IS NULL THEN 1 ELSE 0 END) as station_null_count,
    SUM(CASE WHEN line_name IS NULL THEN 1 ELSE 0 END) as line_name_null_count,
    SUM(CASE WHEN division IS NULL THEN 1 ELSE 0 END) as division_null_count,
    SUM(CASE WHEN audit_date IS NULL THEN 1 ELSE 0 END) as audit_date_null_count,
    SUM(CASE WHEN audit_time IS NULL THEN 1 ELSE 0 END) as audit_time_null_count,
    SUM(CASE WHEN description IS NULL THEN 1 ELSE 0 END) as description_null_count,
    SUM(CASE WHEN entries IS NULL THEN 1 ELSE 0 END) as entries_null_count,
    SUM(CASE WHEN exits IS NULL THEN 1 ELSE 0 END) as exits_null_count
FROM raw_turnstile_2021
UNION ALL
SELECT
    'raw_turnstile_2022' as table_name,
    COUNT(*) as total_rows,
    SUM(CASE WHEN c_a IS NULL THEN 1 ELSE 0 END) as c_a_null_count,
    SUM(CASE WHEN unit IS NULL THEN 1 ELSE 0 END) as unit_null_count,
    SUM(CASE WHEN scp IS NULL THEN 1 ELSE 0 END) as scp_null_count,
    NULL as station_null_count, -- 2022 doesn't have station column
    SUM(CASE WHEN line_name IS NULL THEN 1 ELSE 0 END) as line_name_null_count,
    SUM(CASE WHEN division IS NULL THEN 1 ELSE 0 END) as division_null_count,
    SUM(CASE WHEN audit_date IS NULL THEN 1 ELSE 0 END) as audit_date_null_count,
    SUM(CASE WHEN audit_time IS NULL THEN 1 ELSE 0 END) as audit_time_null_count,
    SUM(CASE WHEN description IS NULL THEN 1 ELSE 0 END) as description_null_count,
    SUM(CASE WHEN entries IS NULL THEN 1 ELSE 0 END) as entries_null_count,
    SUM(CASE WHEN exits IS NULL THEN 1 ELSE 0 END) as exits_null_count
FROM raw_turnstile_2022;

-- Check for duplicate records using proposed primary key
SELECT 
    unit, scp, audit_date, audit_time, 
    COUNT(*) as record_count
FROM raw_turnstile_2019
GROUP BY unit, scp, audit_date, audit_time
HAVING COUNT(*) > 1
ORDER BY record_count DESC;

-- Check date ranges for each table
SELECT 
    'raw_turnstile_2019' as table_name,
    MIN(audit_date) as min_date,
    MAX(audit_date) as max_date
FROM raw_turnstile_2019
UNION ALL
SELECT 
    'raw_turnstile_2020' as table_name,
    MIN(audit_date) as min_date,
    MAX(audit_date) as max_date
FROM raw_turnstile_2020
UNION ALL
SELECT 
    'raw_turnstile_2021' as table_name,
    MIN(audit_date) as min_date,
    MAX(audit_date) as max_date
FROM raw_turnstile_2021
UNION ALL
SELECT 
    'raw_turnstile_2022' as table_name,
    MIN(audit_date) as min_date,
    MAX(audit_date) as max_date
FROM raw_turnstile_2022;

-- Check for RECOVR AUD records
SELECT 'raw_turnstile_2019' as table_name, COUNT(*) as recovr_count 
FROM raw_turnstile_2019 
WHERE description = 'RECOVR AUD'
UNION
SELECT 'raw_turnstile_2020' as table_name, COUNT(*) as recovr_count 
FROM raw_turnstile_2020 
WHERE description = 'RECOVR AUD'
UNION
SELECT 'raw_turnstile_2021' as table_name, COUNT(*) as recovr_count 
FROM raw_turnstile_2021 
WHERE description = 'RECOVR AUD'
UNION
SELECT 'raw_turnstile_2022' as table_name, COUNT(*) as recovr_count 
FROM raw_turnstile_2022 
WHERE description = 'RECOVR AUD';