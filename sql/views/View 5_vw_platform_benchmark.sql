CREATE OR ALTER VIEW dbo.vw_platform_benchmark
AS

SELECT

    platform,

    COUNT(order_id) AS total_orders,

    SUM(order_value_inr) AS total_revenue,

    ROUND( AVG(order_value_inr), 2 ) AS average_order_value,

    ROUND( AVG(service_rating), 2 ) AS average_service_rating,

    ROUND( AVG(delivery_time_minutes), 2 ) AS average_delivery_time,

    SUM(
        CASE
            WHEN refund_requested = 'Yes'
            THEN 1
            ELSE 0
        END ) AS refunded_orders,

    ROUND(
        SUM(
            CASE
                WHEN refund_requested = 'Yes'
                THEN 1
                ELSE 0
            END ) * 100.0 / NULLIF(COUNT(order_id),0), 2 ) AS refund_rate_pct,

    SUM(
        CASE
            WHEN sla_breach_flag = 'Yes'
            THEN 1
            ELSE 0
        END ) AS sla_breach_orders,

    ROUND(
        SUM(
            CASE
                WHEN sla_breach_flag = 'Yes'
                THEN 1
                ELSE 0
            END ) * 100.0 / NULLIF(COUNT(order_id),0), 2 ) AS sla_breach_pct,

    DENSE_RANK() OVER ( ORDER BY SUM(order_value_inr) DESC ) AS revenue_rank,

    DENSE_RANK() OVER ( ORDER BY AVG(service_rating) DESC ) AS customer_experience_rank
FROM dbo.fact_orders

GROUP BY platform;
GO
