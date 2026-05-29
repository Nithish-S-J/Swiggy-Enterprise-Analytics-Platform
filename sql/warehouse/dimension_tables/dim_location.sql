DROP TABLE IF EXISTS dbo.dim_location;
GO

CREATE TABLE dbo.dim_location
(
    location_key INT,
    city VARCHAR(100),
    area VARCHAR(100)
);
GO

INSERT INTO dbo.dim_location

SELECT

    ROW_NUMBER() OVER
    (
        ORDER BY city, area
    ) AS location_key,

    city,
    area

FROM
(
    SELECT DISTINCT
        city,
        area
    FROM dbo.silver_restaurants
) x;
GO
