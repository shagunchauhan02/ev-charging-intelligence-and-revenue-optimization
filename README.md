# ⚡ EV Charging Station Analytics

An end-to-end **Data Analytics & Business Intelligence project** analyzing EV charging sessions, revenue, energy consumption, customer behavior, station performance, demand patterns, utilization, and expansion opportunities.

The project transforms raw charging-session data into actionable business insights using **Python, SQL, PostgreSQL, and Power BI**.

---

## 📌 Project Overview

The increasing adoption of electric vehicles is creating a growing need for efficient charging infrastructure.

This project analyzes **50,000+ EV charging sessions across 30 charging stations** to understand:

- Charging demand patterns
- Revenue performance
- Energy consumption
- Station-level performance
- Customer behavior
- Peak and off-peak demand
- Charger-type performance
- Station utilization
- Potential expansion opportunities

The project follows an end-to-end analytics workflow:

**Raw Data → Data Cleaning → EDA → Feature Engineering → SQL Analysis → KPI Development → Power BI Dashboard → Business Recommendations**

---

## 🎯 Business Objectives

The main objectives of this project are to:

1. Analyze overall EV charging network performance.
2. Identify high-performing and underperforming stations.
3. Understand revenue and energy-consumption drivers.
4. Identify peak charging demand periods.
5. Compare member and guest customer behavior.
6. Analyze charger and connector performance.
7. Measure station utilization using analytical capacity assumptions.
8. Identify potential station expansion opportunities.
9. Build an interactive Power BI dashboard for business decision-making.
10. Convert data into actionable operational insights.

---

## 📊 Dataset

The project contains **50,000+ EV charging sessions across 30 charging stations**.

### Key Dataset Attributes

- Session ID
- Station ID
- Station Name
- City
- Charger Type
- Connector Type
- Start Time
- End Time
- Charging Duration
- Energy Consumed
- Price per kWh
- Revenue
- Vehicle Type
- Battery Capacity
- Customer Type
- Payment Method
- Station Status

### Data Granularity

The primary unit of analysis is an individual **charging session**.

---

# 🛠️ Tech Stack

### Programming & Data Analysis
- Python
- Pandas
- NumPy
- Matplotlib
- Jupyter Notebook

### Database & SQL
- PostgreSQL
- pgAdmin
- SQL
- CTEs
- Window Functions
- Ranking Functions
- Aggregations
- Time-Series Analysis

### Business Intelligence
- Power BI
- Power Query
- DAX
- Data Modeling
- Interactive Dashboards

### Tools
- VS Code
- Git
- GitHub

---

# 🏗️ Project Architecture

```text
                    ┌──────────────────────┐
                    │      Raw Data        │
                    │        CSV           │
                    └──────────┬───────────┘
                               │
                               ▼
                    ┌──────────────────────┐
                    │   Data Cleaning      │
                    │   Python + Pandas    │
                    └──────────┬───────────┘
                               │
                               ▼
                    ┌──────────────────────┐
                    │ Exploratory Analysis │
                    │      EDA             │
                    └──────────┬───────────┘
                               │
                               ▼
                    ┌──────────────────────┐
                    │ Feature Engineering  │
                    │ Time + Demand + KPI  │
                    └──────────┬───────────┘
                               │
                 ┌─────────────┴─────────────┐
                 ▼                           ▼
        ┌─────────────────┐         ┌─────────────────┐
        │   PostgreSQL    │         │     Power BI    │
        │  SQL Analytics  │         │    Dashboard    │
        └────────┬────────┘         └────────┬────────┘
                 │                           │
                 └─────────────┬─────────────┘
                               ▼
                    ┌──────────────────────┐
                    │ Business Insights &  │
                    │ Recommendations      │
                    └──────────────────────┘
