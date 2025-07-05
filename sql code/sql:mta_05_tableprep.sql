-- =====================================
-- FILE 5: 05_combine_tables.sql
-- Union all yearly tables into a single dataset
-- =====================================

-- Create combined table structure
CREATE TABLE combined_turnstile_data (
    c_a VARCHAR(10),
    unit VARCHAR(10),
    scp VARCHAR(10),
    line_name VARCHAR(10),
    division VARCHAR(10),
    audit_date DATE,
    audit_time TIME,
    description VARCHAR(15),
    entries BIGINT,
    exits BIGINT,
    source_year VARCHAR(4)
);

-- Insert data from all four tables
INSERT INTO combined_turnstile_data
SELECT 
    c_a, unit, scp, line_name, division, 
    audit_date, audit_time, description, 
    entries, exits, '2019' as source_year
FROM raw_turnstile_2019
UNION ALL
SELECT 
    c_a, unit, scp, line_name, division, 
    audit_date, audit_time, description, 
    entries, exits, '2020' as source_year
FROM raw_turnstile_2020
UNION ALL
SELECT 
    c_a, unit, scp, line_name, division, 
    audit_date, audit_time, description, 
    entries, exits, '2021' as source_year
FROM raw_turnstile_2021
UNION ALL
SELECT 
    c_a, unit, scp, line_name, division, 
    audit_date, audit_time, description, 
    entries, exits, '2022' as source_year
FROM raw_turnstile_2022;

-- Validate combined data
SELECT source_year, COUNT(*) FROM combined_turnstile_data GROUP BY 1;
SELECT DISTINCT line_name FROM combined_turnstile_data;

-- Check hourly distribution
SELECT 
    EXTRACT(HOUR FROM audit_time) as hour,
    COUNT(*) as record_count
FROM combined_turnstile_data
GROUP BY EXTRACT(HOUR FROM audit_time)
ORDER BY hour;
