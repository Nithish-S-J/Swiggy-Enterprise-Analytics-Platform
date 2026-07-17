CREATE OR ALTER VIEW dbo.vw_customer_retention_risk
AS

WITH customer_metrics AS
(
    SELECT

        fo.customer_id,

        COUNT(fo.order_id) AS total_orders,

        SUM(fo.order_value_inr) AS total_revenue,

        AVG(fo.service_rating) AS avg_rating,

        SUM(
            CASE
                WHEN fo.refund_requested = 'Yes'
                THEN 1
                ELSE 0
            END) AS refund_orders,

        AVG(fo.delivery_time_minutes) AS avg_delivery_time

    FROM dbo.fact_orders fo

    GROUP BY fo.customer_id
)

SELECT

    customer_id,

    total_orders,

    total_revenue,

    ROUND(avg_rating,2) AS avg_rating,

    refund_orders,

    ROUND(avg_delivery_time,2) AS avg_delivery_time,

    CASE

        WHEN total_orders < 5
             AND avg_rating < 3.5
             AND refund_orders >= 1
        THEN 'High Risk'

        WHEN total_orders < 10
             OR avg_rating < 4
        THEN 'Medium Risk'

        ELSE 'Low Risk'

    END AS retention_risk_segment,

    CASE

        WHEN total_orders < 5 THEN 30
        ELSE 0

    END

    +

    CASE

        WHEN avg_rating < 3.5 THEN 30
        ELSE 0

    END

    +

    CASE

        WHEN refund_orders >= 1 THEN 40
        ELSE 0

    END

    AS retention_risk_score

FROM customer_metrics;
GO
