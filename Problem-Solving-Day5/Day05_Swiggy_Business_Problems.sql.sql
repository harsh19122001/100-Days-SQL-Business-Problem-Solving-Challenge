/*
====================================================
Business Problem 13
====================================================

Business Problem:
Which restaurants generate the highest revenue per order?

Business Value:
Revenue per order helps identify premium restaurants
that earn more from each transaction. These restaurants
can be targeted for premium partnerships, featured
placements, and upselling campaigns.

Dataset:
Swiggy Data Warehouse

Schema:
Star Schema

Fact Table:
- fact_swiggy_orders

Dimension Tables:
- dim_restaurant

SQL Concepts Used:
- SUM()
- COUNT()
- GROUP BY
- JOIN
- Revenue Analysis
*/

SELECT
      r.Restaurant_Name,
      SUM(f.Price_INR) AS total_revenue,
      COUNT(f.order_id) AS total_orders,
      ROUND(
          SUM(f.Price_INR) / COUNT(f.order_id),
          2
      ) AS revenue_per_order
FROM fact_swiggy_orders f
JOIN dim_restaurant r
ON f.restaurant_id = r.restaurant_id
GROUP BY r.Restaurant_Name
ORDER BY revenue_per_order DESC;



/*
====================================================
Business Problem 14
====================================================

Business Problem:
Which food categories have the highest average rating?

Business Value:
Identifying highly rated categories helps understand
customer preferences and can support category-focused
marketing and restaurant onboarding strategies.

Dataset:
Swiggy Data Warehouse

Schema:
Star Schema

Fact Table:
- fact_swiggy_orders

Dimension Tables:
- dim_category

SQL Concepts Used:
- AVG()
- GROUP BY
- JOIN
- Rating Analysis
*/

SELECT
      c.Category,
      ROUND(
          AVG(f.Rating),
          2
      ) AS avg_rating,
      COUNT(*) AS total_orders
FROM fact_swiggy_orders f
JOIN dim_category c
ON f.category_id = c.category_id
GROUP BY c.Category
HAVING COUNT(*) >= 20
ORDER BY avg_rating DESC;



/*
====================================================
Business Problem 15
====================================================

Business Problem:
Which cities generate high revenue despite having fewer restaurants?

Business Value:
These cities may have strong customer demand relative
to restaurant availability. Such markets can be targeted
for expansion and new restaurant onboarding.

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
- SUM()
- COUNT(DISTINCT)
- GROUP BY
- JOIN
- Market Analysis
*/

SELECT
      l.City,
      SUM(f.Price_INR) AS total_revenue,
      COUNT(DISTINCT f.restaurant_id) AS total_restaurants,
      ROUND(
          SUM(f.Price_INR) /
          COUNT(DISTINCT f.restaurant_id),
          2
      ) AS revenue_per_restaurant
FROM fact_swiggy_orders f
JOIN dim_location l
ON f.location_id = l.location_id
GROUP BY l.City
ORDER BY revenue_per_restaurant DESC;