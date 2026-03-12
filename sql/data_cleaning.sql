-- Project: Clinical Operations Dashboard
-- File: data_cleaning.sql
-- Purpose: Clean and standardize operational tables for analytics and dashboard reporting
-- Author: Ari M.
-- Date: 2026-03-10
-- Notes: Creates clean views for appointments and referrals for KPI calculations and dashboards



-- 1. Clean Referrals Table
-- Removes duplicate referral events and keeps only the first occurrence per patient and provider combination
CREATE OR REPLACE VIEW referrals_clean AS
SELECT *
FROM (
    SELECT
        r.*,
        ROW_NUMBER() OVER (
            PARTITION BY
                patient_id,
                referring_provider_id,
                referred_to_provider_id,
                referral_order_date
            ORDER BY referral_id
        ) AS row_num
    FROM referrals r
) ranked
WHERE row_num = 1;



-- Check referral cleaning
SELECT COUNT(*) FROM referrals;
SELECT COUNT(*) FROM referrals_clean;

-- Results:
-- count: 282



-- 2. Clean Appointments Table
-- Removes records with NULL critical fields for accurate analytics
CREATE OR REPLACE VIEW appointments_clean AS
SELECT
    appointment_id,
    patient_id,
    provider_id,
    appointment_date,
    appointment_outcome,
    appointment_type
FROM appointments
WHERE
    appointment_date IS NOT NULL
    AND appointment_outcome IS NOT NULL;



-- Check appointments cleaning
SELECT COUNT(*) AS total_appointments FROM appointments;
SELECT COUNT(*) AS clean_appointments FROM appointments_clean;

-- Results:
-- clean_appointments: 1001



-- 3. Department-Level KPIs
-- Calculates total appointments, no-show count, and no-show rate per department
-- Used for dashboard reporting
CREATE OR REPLACE VIEW appointments_kpi_department AS
SELECT
    d.department_name,
    COUNT(a.appointment_id) AS total_appointments,
    SUM(CASE WHEN a.appointment_outcome = 'No-Show' THEN 1 ELSE 0 END) AS no_show_count,
    ROUND(
        100.0 * SUM(CASE WHEN a.appointment_outcome = 'No-Show' THEN 1 ELSE 0 END) / COUNT(a.appointment_id),
        2
    ) AS no_show_rate_percent
FROM appointments_clean a
JOIN providers p ON a.provider_id = p.provider_id
JOIN departments d ON p.department_id = d.department_id
GROUP BY d.department_name;



-- Check Department-Level KPIs
SELECT
    d.department_name,
    COUNT(a.appointment_id) AS total_appointments,
    SUM(CASE WHEN a.appointment_outcome = 'No-Show' THEN 1 ELSE 0 END) AS no_show_count,
    ROUND(
        100.0 * SUM(CASE WHEN a.appointment_outcome = 'No-Show' THEN 1 ELSE 0 END) / COUNT(a.appointment_id),
        2
    ) AS no_show_rate_percent
FROM appointments_clean a
JOIN providers p ON a.provider_id = p.provider_id
JOIN departments d ON p.department_id = d.department_id
GROUP BY d.department_name
ORDER BY no_show_rate_percent DESC;

-- Results
-- department_name, total_appointments,  no_show_count,  no_show_rate_percent
-- Orthopedics      113		              17	          15.04
-- Primary Care     550		              74		      13.45
-- Neurology        75		              9		          12.00
-- Cardiology       107		              12		      11.21
-- Dermatology      156		              15		      9.62



-- 4. Provider-Level KPIs
-- Calculates total appointments, no-show count, and no-show rate per provider
-- Includes department name for dashboard filtering
CREATE OR REPLACE VIEW appointments_kpi_provider AS
SELECT
    p.provider_id,
    p.provider_name,
    d.department_name,
    COUNT(a.appointment_id) AS total_appointments,
    SUM(CASE WHEN a.appointment_outcome = 'No-Show' THEN 1 ELSE 0 END) AS no_show_count,
    ROUND(
        100.0 * SUM(CASE WHEN a.appointment_outcome = 'No-Show' THEN 1 ELSE 0 END) / COUNT(a.appointment_id),
        2
    ) AS no_show_rate_percent
FROM appointments_clean a
JOIN providers p ON a.provider_id = p.provider_id
JOIN departments d ON p.department_id = d.department_id
GROUP BY p.provider_id, p.provider_name, d.department_name;



-- Checks Provider-Level KPIs
SELECT
    provider_id,
    COUNT(*) AS total_appointments,
    SUM(CASE WHEN appointment_outcome = 'No-Show' THEN 1 ELSE 0 END) AS no_show_count,
    ROUND(
        100.0 * SUM(CASE WHEN appointment_outcome = 'No-Show' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS no_show_rate_percent
FROM appointments_clean
GROUP BY provider_id
ORDER BY no_show_rate_percent DESC;

-- Results:
-- provider_id,	total_appointments, no_show_count,  no_show_rate_percent
-- 5	        56	                13	             23.21
-- 12	        38	                8	             221.05
-- 16	        45	                9	             220.00
-- 19	        37	                7	             218.92
-- 13	        39	                6	             215.38
-- 6	        80	                12	             215.00
-- 10	        34	                5	             214.71
-- 2	        77	                10	             212.99
-- 7	        78	                10	             212.82
-- 8	        63	                8	             212.70
-- 3	        61	                7	             211.48
-- 4	        77	                8	             210.39
-- 11	        29	                3	             210.34
-- 1	        58	                6	             210.34
-- 9	        44	                4	             29.09
-- 14	        36	                3	             28.33
-- 18	        33	                2	             26.06
-- 15	        38	                2	             25.26
-- 20	        38	                2	             25.26
-- 17	        40	                2	             25.00







