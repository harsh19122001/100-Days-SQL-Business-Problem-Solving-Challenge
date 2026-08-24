/*
====================================================
Business Problem 19
====================================================

Business Problem:
Which restaurants have the most diverse menu offerings?

Business Value:
Restaurants with a wider variety of dishes can appeal
to a broader customer base and potentially increase
customer retention. Identifying such restaurants helps
understand successful menu diversification strategies.

Dataset:
Swiggy Data Warehouse

Schema:
Star Schema

Fact Table:
- fact_swiggy_orders

Dimension Tables:
- dim_restaurant
- dim_dish

SQL Concepts Used:
- COUNT(DISTINCT)
- GROUP BY
- JOIN
- Menu Analysis
*/

SELECT
       r.Restaurant_Name,
       COUNT(DISTINCT d.Dish_Name) AS diverse_menu
FROM fact_swiggy_orders f
JOIN dim_dish d
ON d.dish_id = f.dish_id
JOIN dim_restaurant r
ON r.restaurant_id = f.restaurant_id
GROUP BY r.Restaurant_Name
ORDER BY diverse_menu DESC
LIMIT 10;



/*
====================================================
Business Problem 20
====================================================

Business Problem:
Which cities have the highest average restaurant rating?

Business Value:
Understanding city-level restaurant satisfaction helps
identify markets where restaurants consistently deliver
better customer experiences. These insights can support
expansion, marketing, and quality improvement efforts.

Dataset:
Swiggy Data Warehouse

Schema:
Star Schema

Fact Table:
- fact_swiggy_orders

Dimension Tables:
- dim_location
- dim_restaurant

SQL Concepts Used:
- CTE
- AVG()
- GROUP BY
- JOIN
- Rating Analysis
*/

WITH restaurant_rating AS(
    SELECT
          l.City,
          r.Restaurant_Name,
          AVG(f.Rating) AS restaurant_avg_rating
    FROM fact_swiggy_orders f
    JOIN dim_location l
    ON f.location_id = l.location_id
    JOIN dim_restaurant r
    ON f.restaurant_id = r.restaurant_id
    GROUP BY l.City, r.Restaurant_Name
)

SELECT
      City,
      AVG(restaurant_avg_rating) AS city_avg_restaurant_rating
FROM restaurant_rating
GROUP BY City
ORDER BY city_avg_restaurant_rating DESC
LIMIT 10;



/*
====================================================
Business Problem 21
====================================================

Business Problem:
Which restaurants contribute the highest percentage of revenue within their city?

Business Value:
Revenue contribution analysis helps identify dominant
restaurants in each market. Understanding which
restaurants drive the largest share of city revenue
supports partnership, promotional, and competitive
strategy decisions.

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
- JOIN
- Revenue Contribution Analysis
*/

WITH restaurant_revenue AS (
    SELECT
        l.City,
        r.Restaurant_Name,
        SUM(f.Price_INR) AS total_revenue_restaurant
    FROM fact_swiggy_orders f
    JOIN dim_restaurant r
        ON r.restaurant_id = f.restaurant_id
    JOIN dim_location l
        ON l.location_id = f.location_id
    GROUP BY l.City, r.Restaurant_Name
),

city_revenue AS (
    SELECT
        l.City,
        SUM(f.Price_INR) AS total_revenue_city
    FROM fact_swiggy_orders f
    JOIN dim_location l
        ON l.location_id = f.location_id
    GROUP BY l.City
),

revenue_contribution AS (
    SELECT
        rr.City,
        rr.Restaurant_Name,
        ROUND(
            (rr.total_revenue_restaurant * 100.0)
            / cr.total_revenue_city,
            2
        ) AS percentage_contribution,
        RANK() OVER(
            PARTITION BY rr.City
            ORDER BY
            (rr.total_revenue_restaurant * 100.0)
            / cr.total_revenue_city DESC
        ) AS rnk
    FROM restaurant_revenue rr
    JOIN city_revenue cr
        ON rr.City = cr.City
)

SELECT
       City,
       Restaurant_Name,
       percentage_contribution
FROM revenue_contribution
WHERE rnk = 1
ORDER BY percentage_contribution DESC;