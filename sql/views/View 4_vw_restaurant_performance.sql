CREATE OR ALTER VIEW dbo.vw_restaurant_performance
AS

SELECT

    dr.restaurant_key,

    dr.restaurant_id,

    dr.restaurant_name,

    dr.city,

    dr.area,

    dr.cuisine_types,

    dr.cost_category,

    dr.restaurant_rating_category,

    COUNT(fo.order_id) AS total_orders,

    SUM(fo.order_value_inr) AS total_revenue,

    ROUND( AVG(fo.order_value_inr), 2 ) AS avg_order_value,

    ROUND( AVG(fo.service_rating), 2 ) AS avg_customer_rating,

    ROUND( AVG(fo.delivery_time_minutes), 2 ) AS avg_delivery_time,

    SUM(
        CASE
            WHEN fo.refund_requested = 'Yes'
            THEN 1
            ELSE 0
        END ) AS refunded_orders,

    ROUND(

        SUM(
            CASE
                WHEN fo.refund_requested = 'Yes'
                THEN 1
                ELSE 0
            END ) * 100.0  / NULLIF(COUNT(fo.order_id),0), 2 ) AS refund_rate_pct,

    DENSE_RANK() OVER ( ORDER BY  SUM(fo.order_value_inr) DESC ) AS revenue_rank

FROM dbo.fact_orders as fo

INNER JOIN dbo.dim_restaurants as dr
    ON fo.restaurant_key = dr.restaurant_key

GROUP BY

    dr.restaurant_key,
    dr.restaurant_id,
    dr.restaurant_name,
    dr.city,
    dr.area,
    dr.cuisine_types,
    dr.cost_category,
    dr.restaurant_rating_category;
GO
