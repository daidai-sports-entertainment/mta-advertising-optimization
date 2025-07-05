- =====================================
-- FILE 7: 07_create_analytics_table.sql
-- Create the final analytics table with all business logic
-- =====================================

CREATE TABLE turnstile_analytics AS
WITH base_data AS (
    SELECT
        entries_interval,
        exits_interval,
        audit_date,
        EXTRACT(YEAR FROM audit_date) AS year,
        EXTRACT(MONTH FROM audit_date) AS month,
        TO_CHAR(audit_date, 'Month') AS month_name,
        EXTRACT(DAY FROM audit_date) AS day,
        EXTRACT(DOW FROM audit_date) AS day_of_week,
        CASE WHEN EXTRACT(DOW FROM audit_date) IN (0, 6) THEN FALSE ELSE TRUE END AS is_weekday,
        audit_time,
        EXTRACT(HOUR FROM audit_time) AS hour_of_day,
        CASE
            WHEN EXTRACT(HOUR FROM audit_time) BETWEEN 0 AND 5 THEN 'Early Morning (12AM-6AM)'
            WHEN EXTRACT(HOUR FROM audit_time) BETWEEN 6 AND 9 THEN 'Morning Rush (6AM-10AM)'
            WHEN EXTRACT(HOUR FROM audit_time) BETWEEN 10 AND 13 THEN 'Midday (10AM-2PM)'
            WHEN EXTRACT(HOUR FROM audit_time) BETWEEN 14 AND 16 THEN 'Afternoon (2PM-5PM)'
            WHEN EXTRACT(HOUR FROM audit_time) BETWEEN 17 AND 20 THEN 'Evening Rush (5PM-9PM)'
            ELSE 'Late Night (9PM-12AM)'
        END AS time_block,
        CASE
            WHEN EXTRACT(MONTH FROM audit_date) IN (12, 1, 2) THEN 'Winter'
            WHEN EXTRACT(MONTH FROM audit_date) IN (3, 4, 5) THEN 'Spring'
            WHEN EXTRACT(MONTH FROM audit_date) IN (6, 7, 8) THEN 'Summer'
            ELSE 'Fall'
        END AS season,
        CASE
            WHEN SUBSTRING(scp, 1, 2) = '01' THEN 'Northbound'
            WHEN SUBSTRING(scp, 1, 2) = '00' THEN 'Southbound'
            ELSE 'Other'
        END AS direction,
        scp AS turnstile_id,
        unit,
        line_name
    FROM turnstile_traffic_77th
    WHERE entries_interval > 0 OR exits_interval > 0
)
SELECT
    year,
    month,
    month_name,
    season,
    day,
    day_of_week,
    is_weekday,
    hour_of_day,
    time_block,
    direction,
    turnstile_id,
    unit,
    line_name,
    SUM(entries_interval) AS total_entries,
    SUM(exits_interval) AS total_exits,
    COUNT(*) AS record_count,
    CASE 
        WHEN SUM(exits_interval) = 0 THEN NULL 
        ELSE ROUND((SUM(entries_interval) * 100.0 / SUM(exits_interval))::numeric, 1)
    END AS entry_exit_ratio
FROM base_data
GROUP BY
    year, month, month_name, season, day, day_of_week, is_weekday,
    hour_of_day, time_block, direction, turnstile_id, unit, line_name
ORDER BY
    year, month, day, hour_of_day, direction, turnstile_id;
