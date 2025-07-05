-- =====================================
-- FILE 1: 01_setup_raw_tables.sql
-- Creates initial raw data tables for each year
-- =====================================

-- Create raw tables for data imports
CREATE TABLE raw_turnstile_2019 (
    c_a VARCHAR(10),
    unit VARCHAR(10),
    scp VARCHAR(10),
    station VARCHAR(50),
    line_name VARCHAR(10),
    division VARCHAR(10),
    audit_date DATE,
    audit_time TIME,
    description VARCHAR(15),
    entries BIGINT,
    exits BIGINT
);

CREATE TABLE raw_turnstile_2020 (
    c_a VARCHAR(10),
    unit VARCHAR(10),
    scp VARCHAR(10),
    station VARCHAR(50),
    line_name VARCHAR(10),
    division VARCHAR(10),
    audit_date DATE,
    audit_time TIME,
    description VARCHAR(15),
    entries BIGINT,
    exits BIGINT
);

CREATE TABLE raw_turnstile_2021 (
    c_a VARCHAR(10),
    unit VARCHAR(10),
    scp VARCHAR(10),
    station VARCHAR(50),
    line_name VARCHAR(10),
    division VARCHAR(10),
    audit_date DATE,
    audit_time TIME,
    description VARCHAR(15),
    entries BIGINT,
    exits BIGINT
);

CREATE TABLE raw_turnstile_2022 (
    c_a VARCHAR(10),
    unit VARCHAR(10),
    scp VARCHAR(10),
    line_name VARCHAR(10),
    division VARCHAR(10),
    audit_date DATE,
    audit_time TIME,
    description VARCHAR(15),
    entries BIGINT,
    exits BIGINT
);