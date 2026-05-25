DROP TABLE IF EXISTS dbo.dim_restaurants;
GO

CREATE TABLE dbo.dim_restaurants (
    restaurant_id INT NOT NULL,
    restaurant_name VARCHAR(255) NOT NULL,
    cuisine_types VARCHAR(255),
    average_rating DECIMAL(3,2),
    restaurant_rating_category VARCHAR(50),
    total_ratings INT,
    price_tier INT,
    cost_category VARCHAR(50)
);
GO

INSERT INTO dbo.dim_restaurants
SELECT 
    restaurant_id,
    restaurant_name,
    cuisine_types,
    average_rating,
    restaurant_rating_category,
    total_ratings,
    price,
    cost_category
FROM dbo.silver_restaurants;
GO
