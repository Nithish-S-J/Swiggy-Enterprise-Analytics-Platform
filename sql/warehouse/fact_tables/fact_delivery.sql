DROP TABLE IF EXISTS dbo.fact_deliveries;
GO

CREATE TABLE dbo.fact_deliveries
(
    delivery_id VARCHAR(100),

    restaurant_key INT,

    location_key INT,

    delivery_person_id VARCHAR(100),

    delivery_person_age INT,

    delivery_person_rating DECIMAL(5,2),

    order_type VARCHAR(50),

    vehicle_type VARCHAR(50),

    delivery_time_minutes INT,

    sla_breach_flag VARCHAR(10),

    delivery_speed_category VARCHAR(50),

    delivery_partner_performance VARCHAR(50)
);
GO

INSERT INTO dbo.fact_deliveries

SELECT

    sd.delivery_id,

    CAST(
        ABS(CAST(CHECKSUM(sd.delivery_id) AS BIGINT))
        % 8680
    AS INT) + 1 AS restaurant_key,

    CAST(
        ABS(CAST(CHECKSUM(CONCAT(sd.delivery_id,'LOC')) AS BIGINT))
        % 843
    AS INT) + 1 AS location_key,

    sd.delivery_person_id,

    TRY_CAST(sd.delivery_person_age AS INT),

    TRY_CAST(sd.delivery_person_rating AS DECIMAL(5,2)),

    sd.order_type,

    sd.vehicle_type,

    TRY_CAST(sd.delivery_time_minutes AS INT),

    CASE
        WHEN TRY_CAST(sd.delivery_time_minutes AS INT) > 35
        THEN 'Yes'
        ELSE 'No'
    END AS sla_breach_flag,

    sd.delivery_speed_category,

    sd.delivery_partner_performance

FROM dbo.silver_deliveries sd;
GO
