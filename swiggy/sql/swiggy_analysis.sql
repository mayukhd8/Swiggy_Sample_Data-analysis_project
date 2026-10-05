-- Swiggy Customer & Order Analytics
-- Database: PostgreSQL
-- Purpose: Portfolio analysis using SQL + Power BI

-- ============================================================
-- 1. BASIC DATA VALIDATION
-- ============================================================

SELECT COUNT(*) AS total_orders
FROM public.orders;

SELECT
    SUM(amount) AS total_revenue,
    ROUND(AVG(amount), 2) AS average_order_value,
    MIN(amount) AS minimum_order_value,
    MAX(amount) AS maximum_order_value
FROM public.orders;

-- ============================================================
-- 2. DATE CONVERSION / DATE RANGE
-- ============================================================

SELECT
    MIN(TO_DATE(order_date, 'DD-MM-YYYY')) AS first_order_date,
    MAX(TO_DATE(order_date, 'DD-MM-YYYY')) AS latest_order_date
FROM public.orders;

-- ============================================================
-- 3. REGISTERED VS PURCHASING CUSTOMERS
-- ============================================================

SELECT COUNT(*) AS registered_customers
FROM public.users;

SELECT COUNT(DISTINCT user_id) AS purchasing_customers
FROM public.orders;

SELECT
    ROUND(
        COUNT(DISTINCT o.user_id)::numeric
        / NULLIF(COUNT(DISTINCT u.user_id), 0) * 100,
        2
    ) AS customer_activation_rate_pct
FROM public.users u
LEFT JOIN public.orders o
    ON u.user_id = o.user_id;

-- ============================================================
-- 4. CUSTOMER PERFORMANCE
-- ============================================================

SELECT
    u.user_id,
    u.name,
    COUNT(o.order_id) AS total_orders,
    COALESCE(SUM(o.amount), 0) AS total_revenue,
    ROUND(AVG(o.amount), 2) AS average_order_value
FROM public.users u
LEFT JOIN public.orders o
    ON u.user_id = o.user_id
GROUP BY u.user_id, u.name
ORDER BY total_revenue DESC;

-- ============================================================
-- 5. CUSTOMER REVENUE CONTRIBUTION
-- ============================================================

WITH customer_revenue AS (
    SELECT
        user_id,
        SUM(amount) AS revenue
    FROM public.orders
    GROUP BY user_id
)
SELECT
    u.name,
    cr.revenue,
    ROUND(
        cr.revenue / SUM(cr.revenue) OVER () * 100,
        2
    ) AS revenue_contribution_pct
FROM customer_revenue cr
JOIN public.users u
    ON u.user_id = cr.user_id
ORDER BY cr.revenue DESC;

-- ============================================================
-- 6. CUSTOMER AOV SEGMENTATION
-- ============================================================

WITH customer_metrics AS (
    SELECT
        u.user_id,
        u.name,
        COUNT(o.order_id) AS total_orders,
        COALESCE(SUM(o.amount), 0) AS total_revenue,
        AVG(o.amount) AS aov
    FROM public.users u
    LEFT JOIN public.orders o
        ON u.user_id = o.user_id
    GROUP BY u.user_id, u.name
)
SELECT
    user_id,
    name,
    total_orders,
    total_revenue,
    ROUND(aov, 2) AS aov,
    CASE
        WHEN total_orders = 0 THEN 'No Orders'
        WHEN aov >= 500 THEN 'High Value'
        WHEN aov >= 350 THEN 'Mid Value'
        ELSE 'Low Value'
    END AS customer_segment
FROM customer_metrics
ORDER BY total_revenue DESC;

-- ============================================================
-- 7. SEGMENT SUMMARY
-- ============================================================

WITH customer_metrics AS (
    SELECT
        u.user_id,
        COUNT(o.order_id) AS total_orders,
        COALESCE(SUM(o.amount), 0) AS total_revenue,
        AVG(o.amount) AS aov
    FROM public.users u
    LEFT JOIN public.orders o
        ON u.user_id = o.user_id
    GROUP BY u.user_id
),
segmented AS (
    SELECT *,
        CASE
            WHEN total_orders = 0 THEN 'No Orders'
            WHEN aov >= 500 THEN 'High Value'
            WHEN aov >= 350 THEN 'Mid Value'
            ELSE 'Low Value'
        END AS customer_segment
    FROM customer_metrics
)
SELECT
    customer_segment,
    COUNT(*) AS customers,
    SUM(total_revenue) AS segment_revenue,
    ROUND(AVG(NULLIF(aov, 0)), 2) AS average_segment_aov
FROM segmented
GROUP BY customer_segment
ORDER BY segment_revenue DESC;

-- ============================================================
-- 8. RESTAURANT PERFORMANCE
-- ============================================================

SELECT
    r.r_name,
    COUNT(o.order_id) AS total_orders,
    SUM(o.amount) AS total_revenue,
    ROUND(AVG(o.amount), 2) AS average_order_value
FROM public.restaurants r
LEFT JOIN public.orders o
    ON r.r_id = o.r_id
GROUP BY r.r_id, r.r_name
ORDER BY total_revenue DESC;

-- ============================================================
-- 9. MONTHLY REVENUE TREND
-- ============================================================

SELECT
    DATE_TRUNC(
        'month',
        TO_DATE(order_date, 'DD-MM-YYYY')
    )::date AS month,
    COUNT(order_id) AS total_orders,
    SUM(amount) AS total_revenue
FROM public.orders
GROUP BY 1
ORDER BY 1;

-- ============================================================
-- 10. LATEST ORDER BY CUSTOMER
-- ============================================================

SELECT
    u.name,
    MAX(TO_DATE(o.order_date, 'DD-MM-YYYY')) AS latest_order_date
FROM public.users u
JOIN public.orders o
    ON u.user_id = o.user_id
GROUP BY u.user_id, u.name
ORDER BY latest_order_date DESC;

-- ============================================================
-- DATA GRAIN NOTE
-- ============================================================
-- public.orders = one row per order.
-- public.order_details = one row per food item associated with an order.
--
-- Do NOT SUM(public.orders.amount) after directly joining orders
-- to order_details, because an order can appear multiple times
-- and revenue can be double-counted.
