WITH numbers AS
(
    SELECT 0 AS n
    UNION ALL SELECT 1
    UNION ALL SELECT 2
    UNION ALL SELECT 3
    UNION ALL SELECT 4
    UNION ALL SELECT 5
    UNION ALL SELECT 6
    UNION ALL SELECT 7
    UNION ALL SELECT 8
    UNION ALL SELECT 9
)

INSERT INTO dim_date
SELECT
    CAST(FORMAT(DATEADD(DAY,
        ROW_NUMBER() OVER (ORDER BY a.n) - 1,
        '2025-01-01'),'yyyyMMdd') AS INT),

    DATEADD(DAY,
        ROW_NUMBER() OVER (ORDER BY a.n) - 1,
        '2025-01-01'),

    YEAR(DATEADD(DAY,
        ROW_NUMBER() OVER (ORDER BY a.n) - 1,
        '2025-01-01')),

    DATEPART(QUARTER,
        DATEADD(DAY,
        ROW_NUMBER() OVER (ORDER BY a.n) - 1,
        '2025-01-01')),

    MONTH(DATEADD(DAY,
        ROW_NUMBER() OVER (ORDER BY a.n) - 1,
        '2025-01-01')),

    DATENAME(MONTH,
        DATEADD(DAY,
        ROW_NUMBER() OVER (ORDER BY a.n) - 1,
        '2025-01-01')),

    DAY(DATEADD(DAY,
        ROW_NUMBER() OVER (ORDER BY a.n) - 1,
        '2025-01-01')),

    DATENAME(WEEKDAY,
        DATEADD(DAY,
        ROW_NUMBER() OVER (ORDER BY a.n) - 1,
        '2025-01-01')),

    DATEPART(WEEKDAY,
        DATEADD(DAY,
        ROW_NUMBER() OVER (ORDER BY a.n) - 1,
        '2025-01-01')),

    CASE
        WHEN DATENAME(WEEKDAY,
            DATEADD(DAY,
            ROW_NUMBER() OVER (ORDER BY a.n) - 1,
            '2025-01-01'))
        IN ('Saturday','Sunday')
        THEN 'Weekend'
        ELSE 'Weekday'
    END

FROM numbers a
CROSS JOIN numbers b
CROSS JOIN numbers c;
