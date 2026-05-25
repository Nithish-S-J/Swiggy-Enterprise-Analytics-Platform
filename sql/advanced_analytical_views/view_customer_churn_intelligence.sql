------The Growth Marketing team needs to track Customer Lifetime Value (CLV) and flag frequency decay
------before a user churns. Static dates fail here. We need a dynamic calculation tracking time
-------since a user's last order compared to their historic purchasing frequency.---


CREATE OR ALTER VIEW dbo.view_customer_churn_intelligence AS
WITH OrderIntervals AS (
    SELECT 
        customer_id,
        order_id,
        order_date,
        order_value_inr,
        -- Get the previous order timestamp to analyze frequency gaps
        LAG(order_date, 1) OVER (PARTITION BY customer_id ORDER BY order_date) AS previous_order_date,
        -- Find the absolute last operational date available in the entire warehouse
        MAX(order_date) OVER() AS max_warehouse_date
    FROM dbo.fact_orders
),
CustomerMetrics AS (
    SELECT 
        customer_id,
        COUNT(order_id) AS total_lifetime_orders,
        SUM(order_value_inr) AS lifetime_revenue,
        MAX(order_date) AS final_purchase_date,
        MAX(max_warehouse_date) AS warehouse_anchor_date,
        -- Calculate the average number of days between orders for this specific customer
        ISNULL(AVG(DATEDIFF(DAY, previous_order_date, order_date)), 0) AS avg_days_between_purchases
    FROM OrderIntervals
    GROUP BY customer_id
)
SELECT 
    cm.customer_id,
    c.customer_segment,
    c.customer_type,
    cm.total_lifetime_orders,
    cm.lifetime_revenue,
    DATEDIFF(DAY, cm.final_purchase_date, cm.warehouse_anchor_date) AS days_since_last_order,
    ROUND(cm.avg_days_between_purchases, 2) AS calculated_purchase_cycle_days,
    -- Business Logic Rule Engine
    CASE 
        WHEN DATEDIFF(DAY, cm.final_purchase_date, cm.warehouse_anchor_date) > 60 THEN 'CHURNED'
        WHEN DATEDIFF(DAY, cm.final_purchase_date, cm.warehouse_anchor_date) > (cm.avg_days_between_purchases * 2) AND cm.avg_days_between_purchases > 0 THEN 'HIGH RISK FREQUENCY DECAY'
        ELSE 'ACTIVE / RETAINED'
    END AS automated_churn_risk_status
FROM CustomerMetrics cm
INNER JOIN dbo.dim_customers c ON cm.customer_id = c.customer_id;
GO
