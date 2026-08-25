/*
====================================================
Business Problem 22
====================================================

Business Problem:
Which restaurants show the biggest gap between their average rating and city average rating?

Business Value:
Comparing restaurant ratings against city benchmarks
helps identify restaurants that significantly outperform
or underperform local competition. This insight can
support quality improvement initiatives and promotional
strategies.

Dataset:
Swiggy Data Warehouse

Schema:
Star Schema

Fact Table:
- fact_swiggy_orders

Dimension Tables:
- dim_restaurant
- dim_location

SQL Concepts Used:
- CTE
- AVG()
- JOIN
- GROUP BY
- Benchmark Analysis
*/

WITH restaurant_avg_rating AS (
    SELECT
        r.Restaurant_Name,
        l.City,
        AVG(f.Rating) AS avg_restaurant_rating
    FROM fact_swiggy_orders f
    JOIN dim_restaurant r
        ON f.restaurant_id = r.restaurant_id
    JOIN dim_location l
        ON f.location_id = l.location_id
    GROUP BY r.Restaurant_Name, l.City
),

city_avg_rating AS (
    SELECT
        l.City,
        AVG(f.Rating) AS avg_city_rating
    FROM fact_swiggy_orders f
    JOIN dim_location l
        ON f.location_id = l.location_id
    GROUP BY l.City
)

SELECT
    ra.Restaurant_Name,
    ra.City,
    ROUND(ra.avg_restaurant_rating,2) AS restaurant_rating,
    ROUND(ca.avg_city_rating,2) AS city_rating,
    ROUND(
        ABS(ra.avg_restaurant_rating - ca.avg_city_rating),2
    ) AS gap
FROM restaurant_avg_rating ra
JOIN city_avg_rating ca
    ON ra.City = ca.City
ORDER BY gap DESC
LIMIT 10;



/*
====================================================
Business Problem 23
====================================================

Business Problem:
Which dishes are offered by the largest number of restaurants?

Business Value:
Understanding which dishes appear across the largest
number of restaurants helps identify popular menu trends,
highly competitive food items, and customer favorites
within the platform.

Dataset:
Swiggy Data Warehouse

Schema:
Star Schema

Fact Table:
- fact_swiggy_orders

Dimension Tables:
- dim_dish
- dim_restaurant

SQL Concepts Used:
- COUNT(DISTINCT)
- GROUP BY
- JOIN
- Menu Analysis
*/

SELECT
      d.Dish_Name,
      COUNT(DISTINCT r.Restaurant_Name) AS restaurant_count
FROM fact_swiggy_orders f
JOIN dim_dish d
ON d.dish_id = f.dish_id
JOIN dim_restaurant r
ON r.restaurant_id = f.restaurant_id
GROUP BY d.Dish_Name
ORDER BY restaurant_count DESC
LIMIT 10;



/*
====================================================
Business Problem 24
====================================================

Business Problem:
Which cities have the highest revenue concentration among their top 3 restaurants?

Business Value:
Revenue concentration analysis helps determine whether
a city's revenue is distributed across many restaurants
or heavily dependent on a few dominant players. This can
help assess competitive dynamics and business risk.

Dataset:
Swiggy Data Warehouse

Schema:
Star Schema

Fact Table:
- fact_swiggy_orders

Dimension Tables:
- dim_restaurant
- dim_location

SQL Concepts Used:
- CTE
- SUM()
- RANK()
- Window Functions
- Percentage Analysis
- Revenue Concentration Analysis
*/

WITH restaurant_revenue AS (
    SELECT
        l.City,
        r.Restaurant_Name,
        SUM(f.Price_INR) AS restaurant_revenue
    FROM fact_swiggy_orders f
    JOIN dim_location l
        ON l.location_id = f.location_id
    JOIN dim_restaurant r
        ON r.restaurant_id = f.restaurant_id
    GROUP BY l.City, r.Restaurant_Name
),

restaurant_rank AS (
    SELECT
        City,
        Restaurant_Name,
        restaurant_revenue,
        RANK() OVER (
            PARTITION BY City
            ORDER BY restaurant_revenue DESC
        ) AS rnk
    FROM restaurant_revenue
),

top_3_revenue AS (
    SELECT
        City,
        SUM(restaurant_revenue) AS top_3_revenue
    FROM restaurant_rank
    WHERE rnk <= 3
    GROUP BY City
),

city_revenue AS (
    SELECT
        City,
        SUM(restaurant_revenue) AS total_city_revenue
    FROM restaurant_revenue
    GROUP BY City
)

SELECT
    t.City,
    t.top_3_revenue,
    c.total_city_revenue,
    ROUND(
        (t.top_3_revenue * 100.0) /
        c.total_city_revenue,
        2
    ) AS concentration_percentage
FROM top_3_revenue t
JOIN city_revenue c
    ON t.City = c.City
ORDER BY concentration_percentage DESC;