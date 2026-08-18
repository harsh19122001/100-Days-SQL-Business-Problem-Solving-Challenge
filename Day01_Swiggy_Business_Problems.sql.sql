/*
====================================================
Day 01/100 - SQL Business Problem Solving Challenge
====================================================

Business Problem 1:
Swiggy wants to identify restaurants whose ratings are
below their city's average rating but still receive a
high volume of orders.

Business Value:
These restaurants continue to attract customers despite
lower ratings. This may indicate strong brand loyalty,
competitive pricing, prime locations, or limited competition.
Understanding these factors can help Swiggy improve customer
experience while maintaining order volume.

Tables Used:
- fact_swiggy_orders
- dim_restaurant
- dim_location

SQL Concepts Used:
- CTE
- AVG()
- GROUP BY
- JOIN
- Aggregation
*/
WITH city_avg AS
(
    SELECT
        l.city,
        AVG(f.rating) AS city_avg_rating
    FROM fact_swiggy_orders f
    JOIN dim_location l
        ON l.location_id = f.location_id
    GROUP BY l.city
),

restaurant_stats AS
(
    SELECT
        r.restaurant_name,
        l.city,
        AVG(f.rating) AS restaurant_rating,
        COUNT(f.order_id) AS order_count
    FROM fact_swiggy_orders f
    JOIN dim_restaurant r
        ON f.restaurant_id = r.restaurant_id
    JOIN dim_location l
        ON f.location_id = l.location_id
    GROUP BY r.restaurant_name, l.city
)

SELECT
    rs.restaurant_name,
    rs.city,
    ROUND(rs.restaurant_rating,2) AS restaurant_rating,
    ROUND(ca.city_avg_rating,2) AS city_avg_rating,
    rs.order_count
FROM restaurant_stats rs
JOIN city_avg ca
    ON ca.city = rs.city
WHERE rs.restaurant_rating < ca.city_avg_rating
ORDER BY rs.order_count DESC
LIMIT 10;

/*
====================================================
Business Problem 2
====================================================

Business Problem:
Which locations have the highest number of orders per restaurant?

Business Value:
Locations with high orders per restaurant may indicate
strong customer demand but limited restaurant availability.
Such areas present opportunities for restaurant onboarding,
improved customer choice, and revenue expansion.

Tables Used:
- fact_swiggy_orders
- dim_location

SQL Concepts Used:
- COUNT()
- COUNT(DISTINCT)
- GROUP BY
- JOIN
- Aggregation
*/
SELECT
    l.city,
    COUNT(f.order_id) AS total_orders,
    COUNT(DISTINCT f.restaurant_id) AS total_restaurants,
    ROUND(
        COUNT(f.order_id) * 1.0 /
        COUNT(DISTINCT f.restaurant_id),
        2
    ) AS orders_per_restaurant
FROM fact_swiggy_orders f
JOIN dim_location l
ON f.location_id = l.location_id
GROUP BY l.city
ORDER BY orders_per_restaurant DESC;


/*
====================================================
Business Problem 3
====================================================

Business Problem:
Which restaurants are overly dependent on a single dish
for their revenue?

Business Value:
A restaurant generating a significant portion of its
revenue from one dish faces concentration risk.
If the popularity of that dish declines, overall revenue
may be heavily impacted. Identifying such restaurants
helps promote menu diversification and business stability.

Tables Used:
- fact_swiggy_orders
- dim_restaurant
- dim_dish

SQL Concepts Used:
- CTE
- SUM()
- JOIN
- Revenue Analysis
- Percentage Contribution Analysis
*/
WITH restaurant_revenue AS
(
    SELECT
        restaurant_id,
        SUM(Price_INR) AS total_revenue
    FROM fact_swiggy_orders
    GROUP BY restaurant_id
),

dish_revenue AS
(
    SELECT
        f.restaurant_id,
        r.Restaurant_Name,
        d.Dish_Name,
        SUM(f.Price_INR) AS dish_revenue
    FROM fact_swiggy_orders f
    JOIN dim_restaurant r
    ON f.restaurant_id = r.restaurant_id
    JOIN dim_dish d
    ON f.dish_id = d.dish_id
    GROUP BY
        f.restaurant_id,
        r.Restaurant_Name,
        d.Dish_Name
)

SELECT
    dr.Restaurant_Name,
    dr.Dish_Name,
    dr.dish_revenue,
    rr.total_revenue,
    ROUND(
        dr.dish_revenue * 100.0 /
        rr.total_revenue,
        2
    ) AS revenue_percentage
FROM dish_revenue dr
JOIN restaurant_revenue rr
ON dr.restaurant_id = rr.restaurant_id
WHERE dr.dish_revenue * 100.0 / rr.total_revenue >= 50
ORDER BY revenue_percentage DESC;



