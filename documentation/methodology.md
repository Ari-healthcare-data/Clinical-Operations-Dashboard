# Methodology

## Overview

This project follows a structured workflow that mirrors how healthcare data is typically prepared for reporting and analytics.

The goal was to move from a raw, multi-table dataset to a format that can support reliable analysis and dashboard development.


---

## Approach

Instead of jumping straight into visualization, I focused on building a strong data foundation first. This includes making sure the data is structured correctly, relationships are valid, and key metrics are clearly defined before building any dashboards.

This approach reflects how data is typically handled in healthcare environments, where accuracy and consistency are critical.

---

## Step 1: Data Modeling

The dataset was designed using a relational structure with separate tables for patients, providers, appointments, referrals, and supporting dimensions.

Key considerations:

- Use of primary and foreign keys to maintain relationships
- Separation of entities to avoid duplication
- Clear linkage between operational data (appointments) and supporting data (patients, providers, departments)

Appointments were treated as the central fact table, since most operational metrics (volume, no-shows, utilization) are derived from it.

---

## Step 2: Data Cleaning (Planned in SQL)

The next step is to load the dataset into PostgreSQL and create cleaned versions of the core tables.

Planned cleaning steps include:

- Removing or handling null values in critical fields
- Ensuring unique primary keys (e.g., appointment_id)
- Validating foreign key relationships across tables
- Standardizing date formats
- Filtering out invalid or inconsistent records

The goal is to ensure that downstream analysis is based on reliable and consistent data.

---

## Step 3: Data Transformation & Feature Engineering

After cleaning, I will create derived fields and views to support analysis.

Examples include:

- No-show flag and no-show rate calculations
- Days between referral order and scheduling
- SLA compliance indicators for referrals
- Revenue and lost revenue calculations
- Patient segmentation (age groups, risk levels)

These transformations will be implemented using SQL to create reusable analytical views.

---

## Step 4: KPI Development

Instead of calculating metrics directly in Power BI, I plan to create KPI tables in SQL.

Examples of KPI tables:

- Appointments by department (volume, no-show rate, revenue impact)
- Provider-level performance metrics
- Referral outcomes and leakage rates

This approach ensures that:

- Metrics are consistent across all visuals
- Logic is centralized and easier to maintain
- Power BI is used mainly for visualization, not heavy data processing

---

## Step 5: Data Validation

Before building dashboards, I will validate the data to ensure accuracy.

Planned validation checks:

- Row counts between raw and cleaned tables
- Duplicate detection for key identifiers
- Spot-checking relationships between tables
- Verifying KPI calculations against sample data

This step is important because incorrect metrics can lead to misleading conclusions, especially in a healthcare context.

---

## Step 6: Visualization (Power BI)

Once the data is cleaned and validated, it will be connected to Power BI.

The dashboard will be structured into multiple pages:

- Clinic Operations Overview
- Provider Performance
- Referral Flow and Access

The focus will be on:

- Clear KPIs
- Simple, readable visuals
- Interactive filtering for different segments

---

## Design Philosophy

A few principles guiding this project:

- Accuracy over complexity
- Clear definitions of metrics
- Separation of data preparation and visualization
- Focus on business-relevant questions

---

## Challenges Anticipated

- Managing relationships across multiple tables
- Defining KPIs in a consistent way
- Handling edge cases in synthetic data
- Avoiding overly complex SQL while still building meaningful logic

---

## Summary

The methodology focuses on building a reliable data pipeline from raw data to final insights.

Rather than treating this as a visualization project, I am approaching it as a full analytics workflow, where each step builds on the previous one.
