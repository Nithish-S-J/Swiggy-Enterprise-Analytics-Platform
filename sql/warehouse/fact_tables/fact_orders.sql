DROP TABLE IF EXISTS dbo.fact_orders;
GO

CREATE TABLE dbo.fact_orders
(
    order_id VARCHAR(100),

    customer_id VARCHAR(100),

    restaurant_key INT,

    platform VARCHAR(50),

    order_timestamp DATETIME2(6),

    order_date DATE,

    order_value_inr DECIMAL(10,2),

    delivery_time_minutes INT,

    product_category VARCHAR(100),

    service_rating INT,

    customer_sentiment VARCHAR(50),

    refund_requested VARCHAR(10),

    sla_breach_flag VARCHAR(10),

    high_value_order_flag VARCHAR(20)
);
GO

INSERT INTO dbo.fact_orders

SELECT

    so.order_id,

    so.customer_id,

    CAST(
        ABS(CAST(CHECKSUM(so.order_id) AS BIGINT))
        % 8680
    AS INT) + 1 AS restaurant_key,

    so.platform,

    CAST(so.order_timestamp AS DATETIME2(6)),

    so.order_date,

    so.order_value_inr,

    so.delivery_time_minutes,

    so.product_category,

    so.service_rating,

    so.customer_sentiment,

    CASE
        WHEN ABS(CAST(CHECKSUM(so.order_id) AS BIGINT)) % 20 = 0
        THEN 'Yes'
        ELSE 'No'
    END AS refund_requested,

    CASE
        WHEN so.delivery_time_minutes > 35
        THEN 'Yes'
        ELSE 'No'
    END AS sla_breach_flag,

    CASE
        WHEN so.order_value_inr >= 1500
        THEN 'High'
        ELSE 'Standard'
    END AS high_value_order_flag

FROM dbo.silver_orders so;
GO
