-- ============================================
-- Verify the data
-- ============================================
SELECT COUNT(*)
FROM charging_sessions;


-- ============================================
-- Charging record
-- ============================================
SELECT *
FROM charging_sessions
LIMIT 10;


-- ============================================
-- Query 1: Total revenue
-- ============================================
SELECT 
    SUM(revenue) AS total_revenue
FROM charging_sessions;


-- ============================================
-- Query 2: Total energy
-- ============================================
SELECT 
    SUM(energy_kwh) AS total_energy_kwh
FROM charging_sessions;


-- ============================================
-- Query 3: Total sessions
-- ============================================
SELECT 
    COUNT(*) AS total_sessions
FROM charging_sessions;


-- ============================================
-- Query 4: Average charging duration
-- ============================================
SELECT 
    ROUND(AVG(charging_duration_min), 2) 
        AS avg_charging_duration
FROM charging_sessions;


-- ============================================
-- Query 5: Revenue by city
-- ============================================
SELECT
    city,
    COUNT(*) AS total_sessions,
    ROUND(SUM(energy_kwh), 2) AS total_energy_kwh,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM charging_sessions
GROUP BY city
ORDER BY total_revenue DESC;


-- ============================================
-- Query 6: Top stations
-- ============================================
SELECT
    station_id,
    station_name,
    city,
    COUNT(*) AS total_sessions,
    ROUND(SUM(energy_kwh), 2) AS total_energy_kwh,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM charging_sessions
GROUP BY
    station_id,
    station_name,
    city
ORDER BY total_revenue DESC
LIMIT 10;


-- ============================================
-- Query 7: Charger performance
-- ============================================
SELECT
    charger_type,
    COUNT(*) AS total_sessions,
    ROUND(SUM(energy_kwh), 2) AS total_energy_kwh,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(AVG(revenue), 2) AS avg_revenue_per_session
FROM charging_sessions
GROUP BY charger_type
ORDER BY total_revenue DESC;


-- ============================================
-- Query 8: Peak charging hours
-- ============================================
SELECT
    EXTRACT(HOUR FROM start_time) AS charging_hour,
    COUNT(*) AS total_sessions
FROM charging_sessions
GROUP BY charging_hour
ORDER BY total_sessions DESC;


-- ============================================
-- Query 9: Monthly revenue
-- ============================================
SELECT
    DATE_TRUNC('month', start_time) AS month,
    COUNT(*) AS total_sessions,
    ROUND(SUM(energy_kwh), 2) AS total_energy_kwh,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM charging_sessions
GROUP BY month
ORDER BY month;


-- ============================================
-- Query 10: Customer analysis
-- ============================================
SELECT
    customer_type,
    COUNT(*) AS total_sessions,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(AVG(revenue), 2) AS avg_revenue
FROM charging_sessions
GROUP BY customer_type
ORDER BY total_revenue DESC;

