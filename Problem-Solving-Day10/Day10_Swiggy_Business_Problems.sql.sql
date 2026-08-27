/*
====================================================
Business Problem 28
====================================================

Business Problem:
Which dishes consistently appear among the top revenue-generating dishes across multiple months?

Business Value:
Identifies dishes with sustained customer demand and
revenue performance across time. These dishes can be
prioritized for promotions and menu optimization.

Dataset:
Swiggy Data Warehouse

Schema:
Star Schema

Fact Table:
- fact_swiggy_orders

Dimension Tables:
- dim_dish
- dim_date

SQL Concepts Used:
- CTE
- SUM()
- RANK()
- Window Functions
- Revenue Analysis
*/

WITH monthly_dish_revenue AS (
    SELECT
        d.Dish_Name,
        dt.Year,
        dt.Month,
        SUM(f.Price_INR) AS revenue
    FROM fact_swiggy_orders f
    JOIN dim_dish d
        ON d.dish_id = f.dish_id
    JOIN dim_date dt
        ON dt.date_id = f.date_id
    GROUP BY
        d.Dish_Name,
        dt.Year,
        dt.Month
),

ranked_dishes AS (
    SELECT
        Dish_Name,
        Year,
        Month,
        revenue,
        RANK() OVER(
            PARTITION BY Year, Month
            ORDER BY revenue DESC
        ) AS rnk
    FROM monthly_dish_revenue
)

SELECT
    Dish_Name,
    COUNT(*) AS months_in_top_10
FROM ranked_dishes
WHERE rnk <= 10
GROUP BY Dish_Name
ORDER BY months_in_top_10 DESC;



/*
====================================================
Business Problem 29
====================================================

Business Problem:
Which restaurants generate above-average revenue while maintaining above-average ratings?

Business Value:
Highlights restaurants that achieve both strong
financial performance and customer satisfaction.

Dataset:
Swiggy Data Warehouse

Schema:
Star Schema

Fact Table:
- fact_swiggy_orders

Dimension Tables:
- dim_restaurant

SQL Concepts Used:
- CTE
- AVG()
- SUM()
- Benchmark Analysis
*/

WITH restaurant_metrics AS (
    SELECT
        r.Restaurant_Name,
        SUM(f.Price_INR) AS revenue,
        AVG(f.Rating) AS avg_rating
    FROM fact_swiggy_orders f
    JOIN dim_restaurant r
        ON r.restaurant_id = f.restaurant_id
    GROUP BY r.Restaurant_Name
)

SELECT
    Restaurant_Name,
    revenue,
    ROUND(avg_rating,2) AS avg_rating
FROM restaurant_metrics
WHERE revenue >
(
    SELECT AVG(revenue)
    FROM restaurant_metrics
)
AND avg_rating >
(
    SELECT AVG(avg_rating)
    FROM restaurant_metrics
)
ORDER BY revenue DESC;



/*
====================================================
Business Problem 30
====================================================

Business Problem:
Which cities have the highest average revenue per order?

Business Value:
Identifies cities where customers spend more per
transaction, helping optimize premium offerings and
pricing strategies.

Dataset:
Swiggy Data Warehouse

Schema:
Star Schema

Fact Table:
- fact_swiggy_orders

Dimension Tables:
- dim_location

SQL Concepts Used:
- AVG()
- GROUP BY
- Revenue Analysis
*/

SELECT
    l.City,
    ROUND(AVG(f.Price_INR),2) AS avg_revenue_per_order
FROM fact_swiggy_orders f
JOIN dim_location l
    ON l.location_id = f.location_id
GROUP BY l.City
ORDER BY avg_revenue_per_order DESC;