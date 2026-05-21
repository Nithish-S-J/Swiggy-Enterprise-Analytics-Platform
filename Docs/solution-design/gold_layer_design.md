----------------------------------------------------Gold Tables--------------------------------

fact_orders

Business grain:

One row per order transaction

Measures:

order_value_inr
delivery_time_minutes
service_rating

----------------------------------------------------------------------------------------------


fact_deliveries

Business grain:

One row per delivery operation

Measures:

time_taken_minutes
delivery_partner_ratings

-------------------------------------------------------------------------------------------------

dim_restaurants

Contains:

restaurant_name
cuisine_types
city
rating_category
cost_category

-----------------------------------------------------------------------------------------------------------

dim_platform

Contains:

platform
operational category
dim_date

Contains:

date
month
quarter
year
weekday
weekend_flag
