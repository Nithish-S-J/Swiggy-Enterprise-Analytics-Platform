CREATE OR ALTER VIEW dbo.vw_operational_bottlenecks
AS

SELECT

    fd.vehicle_type,

    fd.delivery_partner_performance,

    fd.delivery_speed_category,

    COUNT(fd.delivery_id) AS total_deliveries,

    ROUND( AVG(fd.delivery_time_minutes),2 ) AS avg_delivery_time_minutes,

    SUM(
        CASE
            WHEN fd.sla_breach_flag = 'Yes'
            THEN 1
            ELSE 0
        END ) AS sla_breach_count,

    ROUND(

        SUM(
            CASE
                WHEN fd.sla_breach_flag = 'Yes'
                THEN 1
                ELSE 0
            END ) * 100.0   /  NULLIF(COUNT(fd.delivery_id),0), 2 ) AS sla_breach_pct,

    ROUND(
        AVG(fd.delivery_person_rating), 2 ) AS avg_delivery_rating,

    DENSE_RANK() OVER ( ORDER BY 
                                ROUND( SUM(
                                         CASE
                                        WHEN fd.sla_breach_flag = 'Yes'
                                        THEN 1
                                        ELSE 0
                     END ) * 100.0  / NULLIF(COUNT(fd.delivery_id),0), 2 ) DESC ) AS bottleneck_rank

FROM dbo.fact_deliveries fd

GROUP BY

    fd.vehicle_type,
    fd.delivery_partner_performance,
    fd.delivery_speed_category;
GO
