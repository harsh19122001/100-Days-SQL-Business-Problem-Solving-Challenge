/*
====================================================
Business Problem 7
====================================================

Business Problem:
Which restaurants consistently maintain above-average ratings across all months?

Business Value:
Consistently high-rated restaurants indicate strong customer
satisfaction and operational excellence. These restaurants
can be prioritized for promotions, featured listings, and
customer retention campaigns.

Dataset:
Swiggy Data Warehouse

Schema:
Star Schema

Fact Table:
- fact_swiggy_orders

Dimension Tables:
- dim_restaurant
- dim_date

SQL Concepts Used:
- CTE
- AVG()
- MIN()
- GROUP BY
- HAVING
*/

WITH monthly_ratings AS (
    SELECT
         r.Restaurant_Name,
         d.Year,
         d.Month,
         AVG(f.Rating) AS avg_rating
    FROM fact_swiggy_orders f
    JOIN dim_restaurant r
    ON r.restaurant_id = f.restaurant_id
    JOIN dim_date d
    ON d.date_id = f.date_id
    GROUP BY
            r.Restaurant_Name,
            d.Year,
            d.Month
)
SELECT
      Restaurant_Name,
      MIN(avg_rating) AS lowest_monthly_rating
FROM monthly_ratings
GROUP BY Restaurant_Name
HAVING MIN(avg_rating) >
(
  SELECT AVG(Rating)
  FROM fact_swiggy_orders
)
ORDER BY lowest_monthly_rating DESC;

/*
====================================================
Business Problem 8
====================================================

Business Problem:
Which food categories contribute the highest revenue in each city?

Business Value:
Understanding city-wise food preferences helps Swiggy
optimize local marketing campaigns, improve restaurant
onboarding decisions, and allocate resources toward
high-performing categories.

Dataset:
Swiggy Data Warehouse

Schema:
Star Schema

Fact Table:
- fact_swiggy_orders

Dimension Tables:
- dim_category
- dim_location

SQL Concepts Used:
- CTE
- SUM()
- RANK()
- Window Functions
- Revenue Analysis
*/

WITH category_revenue AS
(
   SELECT
          l.City,
          c.Category,
          SUM(f.Price_INR) AS revenue,
          RANK() OVER
          (
            PARTITION BY l.City
            ORDER BY SUM(f.Price_INR) DESC
          ) AS rnk
   FROM fact_swiggy_orders f
   JOIN dim_category c
   ON c.category_id = f.category_id
   JOIN dim_location l
   ON l.location_id = f.location_id
   GROUP BY l.City, c.Category
)

SELECT
      City,
      Category,
      Revenue
FROM category_revenue
WHERE rnk = 1
ORDER BY Revenue DESC;

/*
====================================================
Business Problem 9
====================================================

Business Problem:
Which cities have the highest menu diversity?

Business Value:
Cities with greater menu diversity offer customers more
choices and may indicate mature and competitive food
delivery markets. This insight helps identify locations
with broader customer demand and restaurant variety.

Dataset:
Swiggy Data Warehouse

Schema:
Star Schema

Fact Table:
- fact_swiggy_orders

Dimension Tables:
- dim_category
- dim_location

SQL Concepts Used:
- COUNT(DISTINCT)
- GROUP BY
- JOIN
- Market Analysis
*/

SELECT
      l.City,
      COUNT(DISTINCT c.Category) AS menu_diversity
FROM fact_swiggy_orders f
JOIN dim_category c
ON c.category_id = f.category_id
JOIN dim_location l
ON l.location_id = f.location_id
GROUP BY l.City
ORDER BY menu_diversity DESC;