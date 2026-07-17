CREATE OR ALTER VIEW dbo.vw_executive_kpi_summary
AS

SELECT

    /* ==========================
       Revenue Metrics
    ========================== */

    SUM(order_value_inr) AS total_revenue,

    COUNT(order_id) AS total_orders,

    ROUND(AVG(order_value_inr), 2 ) AS average_order_value,

    /* ==========================
       Delivery Metrics
    ========================== */

    ROUND(AVG(delivery_time_minutes), 2) AS average_delivery_time_minutes,

    /* ==========================
       Customer Experience
    ========================== */

    ROUND(AVG(service_rating), 2 ) AS average_service_rating,

    /* ==========================
       Refund Metrics
    ========================== */

    SUM(
        CASE
            WHEN refund_requested = 'Yes'
            THEN 1
            ELSE 0
        END) AS refunded_orders,

    ROUND(
        SUM(
            CASE
                WHEN refund_requested = 'Yes'
                THEN 1
                ELSE 0
            END) * 100.0/ COUNT(order_id),2) AS refund_rate_pct,

    /* ==========================
       SLA Metrics
    ========================== */

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
            END) * 100.0 / COUNT(order_id), 2 ) AS sla_breach_pct,

    /* ==========================
       High Value Orders
    ========================== */

    SUM(
        CASE
            WHEN high_value_order_flag = 'High'
            THEN 1
            ELSE 0
        END ) AS high_value_orders,

    ROUND(
        SUM(
            CASE
                WHEN high_value_order_flag = 'High'
                THEN 1
                ELSE 0
            END ) * 100.0 / COUNT(order_id), 2 ) AS high_value_order_pct

FROM dbo.fact_orders;
GO
