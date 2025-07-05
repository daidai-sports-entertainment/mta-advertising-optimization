-- =====================================
-- FILE 6: 06_interval_calculations.sql
-- Calculate traffic intervals and transform data
-- =====================================

-- Create the transformed table for turnstile traffic data
CREATE TABLE turnstile_traffic_77th (
    id SERIAL PRIMARY KEY,
    c_a VARCHAR(10),
    unit VARCHAR(10),
    scp VARCHAR(10),
    line_name VARCHAR(10),
    division VARCHAR(10),
    audit_date DATE,
    audit_time TIME,
    direction VARCHAR(10), -- 'NORTH' or 'SOUTH' based on SCP
    entries_interval INTEGER,
    exits_interval INTEGER,
    source_year VARCHAR(4),
    day_of_week INTEGER, -- 0 (Sunday) to 6 (Saturday)
    is_weekday BOOLEAN,
    hour_of_day INTEGER
);

-- Calculate interval differences using window functions
-- This handles counter resets and outliers (>10K intervals)
WITH ranked_data AS (
    SELECT
        c_a, unit, scp, line_name, division,
        audit_date, audit_time,
        CASE
            WHEN SUBSTRING(scp, 1, 2) = '01' THEN 'NORTH'
            WHEN SUBSTRING(scp, 1, 2) = '00' THEN 'SOUTH'
            ELSE 'UNKNOWN'
        END as direction,
        entries, exits, source_year,
        EXTRACT(DOW FROM audit_date) as day_of_week,
        CASE WHEN EXTRACT(DOW FROM audit_date) IN (0, 6) THEN FALSE ELSE TRUE END as is_weekday,
        EXTRACT(HOUR FROM audit_time) as hour_of_day,
        LAG(entries) OVER (PARTITION BY scp ORDER BY audit_date, audit_time) as prev_entries,
        LAG(exits) OVER (PARTITION BY scp ORDER BY audit_date, audit_time) as prev_exits
    FROM combined_turnstile_data
)
INSERT INTO turnstile_traffic_77th (
    c_a, unit, scp, line_name, division,
    audit_date, audit_time, direction,
    entries_interval, exits_interval,
    source_year, day_of_week, is_weekday, hour_of_day
)
SELECT
    c_a, unit, scp, line_name, division,
    audit_date, audit_time, direction,
    CASE
        -- Handle counter resets or first reading (prev is null)
        WHEN prev_entries IS NULL THEN 0
        WHEN entries < prev_entries THEN entries
        -- Normal case: calculate difference (limit to reasonable value)
        WHEN (entries - prev_entries) > 10000 THEN 0 -- >10K likely sensor error
        ELSE (entries - prev_entries)
    END as entries_interval,
    CASE
        -- Handle counter resets or first reading (prev is null)
        WHEN prev_exits IS NULL THEN 0
        WHEN exits < prev_exits THEN exits
        -- Normal case: calculate difference (limit to reasonable value)
        WHEN (exits - prev_exits) > 10000 THEN 0 -- >10K likely sensor error
        ELSE (exits - prev_exits)
    END as exits_interval,
    source_year, day_of_week, is_weekday, hour_of_day
FROM ranked_data;