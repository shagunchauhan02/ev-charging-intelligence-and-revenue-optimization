-- ============================================
-- Query 1: Top 3 Stations in Every City
-- ============================================
WITH station_revenue AS (
    SELECT
        city,
        station_id,
        station_name,
        SUM(revenue) AS total_revenue
    FROM charging_sessions
    GROUP BY city, station_id, station_name
),

ranked_stations AS (
    SELECT
        city,
        station_id,
        station_name,
        total_revenue,
        DENSE_RANK() OVER (
            PARTITION BY city
            ORDER BY total_revenue DESC
        ) AS revenue_rank
    FROM station_revenue
)

SELECT
    city,
    station_id,
    station_name,
    ROUND(total_revenue, 2) AS total_revenue,
    revenue_rank
FROM ranked_stations
WHERE revenue_rank <= 3
ORDER BY city, revenue_rank;


-- ============================================
-- Query 2: Monthly Revenue Growth
-- ============================================
WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', start_time) AS month,
        SUM(revenue) AS total_revenue
    FROM charging_sessions
    GROUP BY month
),

revenue_with_previous AS (
    SELECT
        month,
        total_revenue,
        LAG(total_revenue) OVER (
            ORDER BY month
        ) AS previous_month_revenue
    FROM monthly_revenue
)

SELECT
    month,
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(previous_month_revenue, 2) AS previous_month_revenue,
    ROUND(
        (
            (total_revenue - previous_month_revenue)
            / NULLIF(previous_month_revenue, 0)
        ) * 100,
        2
    ) AS revenue_growth_percent
FROM revenue_with_previous
ORDER BY month;


-- ============================================
-- Query 3: Revenue Contribution by City
-- ============================================
WITH city_revenue AS (
    SELECT
        city,
        SUM(revenue) AS total_revenue
    FROM charging_sessions
    GROUP BY city
)

SELECT
    city,
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(
        total_revenue * 100.0 /
        SUM(total_revenue) OVER (),
        2
    ) AS revenue_contribution_percent
FROM city_revenue
ORDER BY total_revenue DESC;


-- ============================================
-- Query 4: Peak Charging Hours
-- ============================================
WITH hourly_demand AS (
    SELECT
        EXTRACT(HOUR FROM start_time)::INT AS charging_hour,
        COUNT(*) AS total_sessions
    FROM charging_sessions
    GROUP BY charging_hour
)

SELECT
    charging_hour,
    total_sessions,
    RANK() OVER (
        ORDER BY total_sessions DESC
    ) AS demand_rank
FROM hourly_demand
ORDER BY demand_rank;


-- ============================================
-- Query 5: Peak Hours by Charger Type
-- ============================================
WITH charger_hourly_demand AS (
    SELECT
        charger_type,
        EXTRACT(HOUR FROM start_time)::INT AS charging_hour,
        COUNT(*) AS total_sessions
    FROM charging_sessions
    GROUP BY charger_type, charging_hour
),

ranked_demand AS (
    SELECT
        charger_type,
        charging_hour,
        total_sessions,
        RANK() OVER (
            PARTITION BY charger_type
            ORDER BY total_sessions DESC
        ) AS demand_rank
    FROM charger_hourly_demand
)

SELECT
    charger_type,
    charging_hour,
    total_sessions,
    demand_rank
FROM ranked_demand
WHERE demand_rank <= 3
ORDER BY charger_type, demand_rank;


-- ============================================
-- Query 6: Running Revenue
-- ============================================
WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', start_time) AS month,
        SUM(revenue) AS monthly_revenue
    FROM charging_sessions
    GROUP BY month
)

SELECT
    month,
    ROUND(monthly_revenue, 2) AS monthly_revenue,
    ROUND(
        SUM(monthly_revenue) OVER (
            ORDER BY month
            ROWS BETWEEN UNBOUNDED PRECEDING
            AND CURRENT ROW
        ),
        2
    ) AS cumulative_revenue
FROM monthly_revenue
ORDER BY month;


-- ============================================
-- Query 7: High-Value Sessions
-- ============================================
SELECT
    session_id,
    station_name,
    city,
    charger_type,
    energy_kwh,
    revenue
FROM charging_sessions
WHERE revenue > (
    SELECT AVG(revenue) + 2 * STDDEV(revenue)
    FROM charging_sessions
)
ORDER BY revenue DESC;


-- ============================================
-- Query 8: Data Quality SQL Check
-- ============================================

--Negative revenue
SELECT COUNT(*) AS invalid_revenue_records
FROM charging_sessions
WHERE revenue < 0;

--Negative energy
SELECT COUNT(*) AS invalid_energy_records
FROM charging_sessions
WHERE energy_kwh <= 0;

--Invalid duration
SELECT COUNT(*) AS invalid_duration_records
FROM charging_sessions
WHERE charging_duration_min <= 0;

--Revenue mismatch
SELECT COUNT(*) AS revenue_mismatch_records
FROM charging_sessions
WHERE ROUND(energy_kwh * price_per_kwh, 2) <> revenue;


-- ============================================
-- Create SQL Analysis View
-- ============================================
CREATE OR REPLACE VIEW station_revenue_analysis AS
SELECT
    station_id,
    station_name,
    city,
    COUNT(*) AS total_sessions,
    ROUND(SUM(energy_kwh), 2) AS total_energy_kwh,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(AVG(revenue), 2) AS avg_revenue_per_session,
    ROUND(AVG(charging_duration_min), 2) AS avg_duration_min
FROM charging_sessions
GROUP BY
    station_id,
    station_name,
    city;

--use
SELECT *
FROM station_revenue_analysis
ORDER BY total_revenue DESC;