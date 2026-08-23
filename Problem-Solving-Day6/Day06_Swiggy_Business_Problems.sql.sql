/*
====================================================
Business Problem 16
====================================================

Business Problem:
Which restaurants receive significantly more orders than the city average?

Business Value:
Identifying restaurants that consistently outperform
the city average helps Swiggy understand successful
business models, customer preferences, and operational
best practices that can be replicated across other
restaurants on the platform.

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
- COUNT()
- GROUP BY
- JOIN
- HAVING
- Benchmark Analysis
*/

WITH avg_city_orders AS(
    SELECT
        City,
        AVG(total_orders) AS avg_orders
    FROM (
        SELECT
            l.City,
            f.restaurant_id,
            COUNT(f.order_id) AS total_orders
        FROM fact_swiggy_orders f
        JOIN dim_location l
        ON l.location_id = f.location_id
        GROUP BY l.City, f.restaurant_id
    ) x
    GROUP BY City
)

SELECT
      r.Restaurant_Name,
      l.City,
      COUNT(f.order_id) AS Total_Orders,
      a.avg_orders AS city_avg_orders
FROM fact_swiggy_orders f
JOIN dim_restaurant r
ON r.restaurant_id = f.restaurant_id
JOIN dim_location l
ON l.location_id = f.location_id
JOIN avg_city_orders a
ON a.City = l.City
GROUP BY
        r.Restaurant_Name,
        l.City,
        a.avg_orders
HAVING COUNT(f.order_id) > a.avg_orders
ORDER BY Total_Orders DESC;



/*
====================================================
Business Problem 17
====================================================

Business Problem:
Which food categories generate high revenue despite having fewer orders?

Business Value:
Some categories attract fewer customers but generate
strong revenue due to higher pricing or premium product
positioning. Identifying these categories helps optimize
marketing spend and improve category-level strategy.

Dataset:
Swiggy Data Warehouse

Schema:
Star Schema

Fact Table:
- fact_swiggy_orders

Dimension Tables:
- dim_category

SQL Concepts Used:
- SUM()
- COUNT()
- GROUP BY
- HAVING
- Subquery
- Revenue Analysis
*/

SELECT
    c.Category,
    COUNT(f.order_id) AS Total_Orders,
    SUM(f.Price_INR) AS Total_Revenue
FROM fact_swiggy_orders f
JOIN dim_category c
    ON c.category_id = f.category_id
GROUP BY c.Category
HAVING COUNT(f.order_id) < (
    SELECT AVG(order_count)
    FROM (
        SELECT
            COUNT(f.order_id) AS order_count
        FROM fact_swiggy_orders f
        JOIN dim_category c
            ON c.category_id = f.category_id
        GROUP BY c.Category
    ) X
)
ORDER BY Total_Revenue DESC;



/*
====================================================
Business Problem 18
====================================================

Business Problem:
Which dishes generate the highest revenue despite receiving fewer orders?

Business Value:
This analysis helps identify premium dishes that
generate strong revenue even without high sales volume.
These dishes can be highlighted through recommendations,
bundling strategies, and promotional campaigns to
maximize overall revenue.

Dataset:
Swiggy Data Warehouse

Schema:
Star Schema

Fact Table:
- fact_swiggy_orders

Dimension Tables:
- dim_dish

SQL Concepts Used:
- SUM()
- COUNT()
- GROUP BY
- HAVING
- Subquery
- Dish Performance Analysis
*/

SELECT
    d.Dish_Name,
    COUNT(f.order_id) AS Total_Orders,
    SUM(f.Price_INR) AS Total_Revenue
FROM fact_swiggy_orders f
JOIN dim_dish d
    ON d.dish_id = f.dish_id
GROUP BY d.Dish_Name
HAVING COUNT(f.order_id) < (
    SELECT AVG(order_count)
    FROM (
        SELECT
            COUNT(order_id) AS order_count
        FROM fact_swiggy_orders
        GROUP BY dish_id
    ) x
)
ORDER BY Total_Revenue DESC;
