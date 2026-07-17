CREATE OR ALTER VIEW dbo.vw_revenue_intelligence
AS

WITH monthly_metrics AS
(
    SELECT

        YEAR(order_date) AS order_year,

        MONTH(order_date) AS order_month,

        FORMAT(order_date,'yyyy-MM') AS year_month,

        platform,

        COUNT(order_id) AS total_orders,

        SUM(order_value_inr) AS total_revenue,

        ROUND( AVG(order_value_inr), 2 ) AS average_order_value

    FROM dbo.fact_orders

    GROUP BY

        YEAR(order_date),
        MONTH(order_date),
        FORMAT(order_date,'yyyy-MM'),
        platform
)

SELECT

    order_year,

    order_month,

    year_month,

    platform,

    total_orders,

    total_revenue,

    average_order_value,

    LAG(total_revenue) OVER ( PARTITION BY platform ORDER BY year_month ) AS previous_month_revenue,

    ROUND((total_revenue  -  LAG(total_revenue)   OVER  ( PARTITION BY platform  ORDER BY year_month )  ) * 100.0
      /
        NULLIF ( LAG(total_revenue) OVER ( PARTITION BY platform ORDER BY year_month ), 0 ), 2 ) AS revenue_growth_pct,

    ROUND(total_revenue * 100.0 / SUM(total_revenue) OVER ( PARTITION BY year_month ), 2 ) AS platform_revenue_share_pct

FROM monthly_metrics;
GO
