# Methodology — Clinical Operations Dashboard

## 1. Data Preparation
- All datasets are synthetic; no real patient or provider data is used.
- Exported raw Excel data into processed CSV files and then imported into PostgreSQL using pgAdmin 4.
- Connected Power BI Desktop to SQL views for dashboard development.
  - Tables included: patients, providers, departments, appointments, referrals, calendar, financial assumptions.

## 2. Data Cleaning & Standardization
- Created **cleaned views**:
  - Created `appointments_clean` to ensure accurate metrics for no-show rates and appointment trends.
    - `appointments_clean`: Removed nulls in critical fields, ensured accurate appointment outcomes
  - Created `referrals_clean` to track referral volume and leakage without duplicates or missing data.
    - `referrals_clean`: Removed duplicates, validated referral IDs and provider references
  - Ensured **no duplicate primary keys** and all foreign key references were valid.

## 3. KPI Calculations
- **Department-level KPIs (`appointments_kpi_department`)**:
  - Total appointments
  - No-show count
  - No-show rate (%)
- **Provider-level KPIs (`appointments_kpi_provider`)**:
  - Total appointments
  - No-show count
  - No-show rate (%)
  - Department mapping for filtering

## 4. Data Validation
- Checked row counts for all tables
- Verified uniqueness of primary keys
- Ensured no nulls in key fields
- Validated foreign key relationships
- Confirmed KPIs were correctly calculated

## 5. Dashboard Design
- Connected **cleaned views** and **KPI tables** to Power BI
- Built **three dashboard pages**:
  1. Clinic Operations Overview
  2. Provider Performance
  3. Access & Referral Flow
- Applied **best practices**:
  - Power BI only accesses validated, KPI-ready data
  - Relationships created only where cross-table analysis is required
  - Metrics formatted clearly for stakeholders
