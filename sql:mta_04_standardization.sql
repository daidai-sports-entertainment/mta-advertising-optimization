-- =====================================
-- FILE 4: 04_data_standardization.sql
-- Standardize formats and handle duplicates
-- =====================================

-- Fix SCP column format inconsistencies in 2020 data
UPDATE raw_turnstile_2020
SET scp = CASE 
    WHEN TRIM(scp) = '1/3/00' THEN '01-03-00'
    WHEN TRIM(scp) = '1/3/01' THEN '01-03-01'
    WHEN TRIM(scp) = '1/3/02' THEN '01-03-02'
    WHEN TRIM(scp) = '' THEN NULL
    ELSE TRIM(scp)
END
WHERE TRIM(scp) IN ('1/3/00', '1/3/01', '1/3/02', '');

-- Handle duplicates in 2021 data with sophisticated logic
-- Create backup before making changes
CREATE TABLE raw_turnstile_2021_backup AS
SELECT * FROM raw_turnstile_2021;

-- Fix duplicate records by adjusting time for records with lower entry/exit values
WITH potential_duplicates AS (
    SELECT
        unit, scp, audit_date, audit_time,
        COUNT(*) as record_count,
        MIN(entries) as min_entries,
        MAX(entries) as max_entries,
        MAX(entries) - MIN(entries) as entry_difference,
        MIN(exits) as min_exits,
        MAX(exits) as max_exits,
        MAX(exits) - MIN(exits) as exit_difference
    FROM raw_turnstile_2021
    GROUP BY unit, scp, audit_date, audit_time
    HAVING COUNT(*) > 1
),
records_to_update AS (
    SELECT 
        r.unit, r.scp, r.audit_date, r.audit_time, r.entries, r.exits
    FROM raw_turnstile_2021 r
    JOIN potential_duplicates p
    ON r.unit = p.unit AND r.scp = p.scp AND r.audit_date = p.audit_date AND r.audit_time = p.audit_time
    WHERE (p.entry_difference > 100 OR p.exit_difference > 100)
    AND (r.entries < p.max_entries OR r.exits < p.max_exits)
)
UPDATE raw_turnstile_2021
SET audit_time = audit_time + INTERVAL '12 hours'
WHERE (unit, scp, audit_date, audit_time, entries, exits) IN (
    SELECT * FROM records_to_update
);

-- Validate time distribution after update
SELECT 
    audit_time,
    COUNT(*) as record_count
FROM raw_turnstile_2021
GROUP BY audit_time
ORDER BY audit_time;