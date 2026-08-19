/*
====================================================
Business Problem 4
====================================================

Business Problem:
Which restaurant categories have the highest average order value?

Business Value:
Categories with a higher average order value contribute
more revenue per transaction. Identifying these categories
helps Swiggy prioritize premium offerings, optimize marketing
campaigns, and improve overall profitability.

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
- HAVING
- JOIN
- Aggregation Analysis
*/

SELECT
       c.Category,
       AVG(f.Price_INR) AS avg_order_value
FROM fact_swiggy_orders f
JOIN dim_category c
ON f.category_id = c.category_id
GROUP BY c.Category
HAVING AVG(f.Price_INR) > (
   SELECT AVG(Price_INR)
   FROM fact_swiggy_orders
)
ORDER BY avg_order_value DESC;



/*
====================================================
Business Problem 5
====================================================

Business Problem:
Which cities generate the highest revenue per restaurant?

Business Value:
Some cities may have fewer restaurants but generate
significantly higher revenue per restaurant. Identifying
such markets helps Swiggy focus expansion efforts,
partnership opportunities, and resource allocation.

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
- SUM()
- COUNT()
- GROUP BY
- JOIN
- Revenue Analysis
*/

SELECT
      l.City,
      SUM(f.Price_INR) / COUNT(r.Restaurant_Name) AS revenue_per_restaurant
FROM fact_swiggy_orders f
JOIN dim_restaurant r
ON f.restaurant_id = r.restaurant_id
JOIN dim_location l
ON f.location_id = l.location_id
GROUP BY l.City
ORDER BY revenue_per_restaurant DESC;



/*
====================================================
Business Problem 6
====================================================

Business Problem:
Which restaurant categories are growing fastest
month-over-month in revenue?

Business Value:
Tracking month-over-month revenue growth helps identify
emerging food trends and high-growth categories.
These insights can support marketing decisions,
restaurant onboarding strategies, and category-focused
promotional campaigns.

Dataset:
Swiggy Data Warehouse

Schema:
Star Schema

Fact Table:
- fact_swiggy_orders

Dimension Tables:
- dim_category
- dim_date

SQL Concepts Used:
- CTE
- LAG()
- Window Functions
- SUM()
- Revenue Growth Analysis
*/

WITH monthly_revenue AS (
    SELECT
        c.Category,
        d.Year,
        d.Month,
        SUM(f.Price_INR) AS revenue
    FROM fact_swiggy_orders f
    JOIN dim_category c
        ON f.category_id = c.category_id
    JOIN dim_date d
        ON f.date_id = d.date_id
    GROUP BY c.Category, d.Year, d.Month
),

previous_month_revenue AS (
    SELECT
        Category,
        Year,
        Month,
        revenue,
        LAG(revenue) OVER(
            PARTITION BY Category
            ORDER BY Year, Month
        ) AS prev_revenue
    FROM monthly_revenue
)

SELECT
    Category,
    Year,
    Month,
    revenue,
    prev_revenue,
    ROUND(
        (revenue - prev_revenue) * 100.0 / prev_revenue,
        2
    ) AS mom_growth_pct
FROM previous_month_revenue
WHERE prev_revenue IS NOT NULL
ORDER BY mom_growth_pct DESC;
