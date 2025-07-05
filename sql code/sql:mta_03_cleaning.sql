-- =====================================
-- FILE 3: 03_data_cleaning.sql
-- Remove unwanted records and handle data quality issues
-- =====================================

-- Remove rows where line_name = 'R' from all tables
DELETE FROM raw_turnstile_2019 WHERE line_name = 'R';
DELETE FROM raw_turnstile_2020 WHERE line_name = 'R';
DELETE FROM raw_turnstile_2021 WHERE line_name = 'R';
DELETE FROM raw_turnstile_2022 WHERE line_name = 'R';

-- Validate line_name removal
SELECT DISTINCT line_name FROM raw_turnstile_2019
UNION
SELECT DISTINCT line_name FROM raw_turnstile_2020
UNION
SELECT DISTINCT line_name FROM raw_turnstile_2021
UNION
SELECT DISTINCT line_name FROM raw_turnstile_2022;

-- Remove RECOVR AUD records from all tables
DELETE FROM raw_turnstile_2019 WHERE description = 'RECOVR AUD';
DELETE FROM raw_turnstile_2020 WHERE description = 'RECOVR AUD';
DELETE FROM raw_turnstile_2021 WHERE description = 'RECOVR AUD';
DELETE FROM raw_turnstile_2022 WHERE description = 'RECOVR AUD';

-- Drop station column from 2019-2021 tables (2022 doesn't have it)
ALTER TABLE raw_turnstile_2019 DROP COLUMN station;
ALTER TABLE raw_turnstile_2020 DROP COLUMN station;
ALTER TABLE raw_turnstile_2021 DROP COLUMN station;