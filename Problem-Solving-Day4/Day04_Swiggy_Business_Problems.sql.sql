/*
====================================================
Business Problem 10
====================================================

Business Problem:
Which restaurants have the highest average order value but receive relatively fewer orders?

Business Value:
Some restaurants generate high revenue per transaction
despite having low order volume. Identifying these
restaurants helps Swiggy uncover premium dining
opportunities and design targeted marketing campaigns
to increase customer reach without sacrificing profitability.

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
- COUNT()
- Subquery
- Aggregation Analysis
*/

WITH restaurant_stats AS (
    SELECT
        r.Restaurant_Name,
        COUNT(*) AS order_count,
        AVG(f.Price_INR) AS avg_order_value
    FROM fact_swiggy_orders f
    JOIN dim_restaurant r
        ON r.restaurant_id = f.restaurant_id
    GROUP BY r.Restaurant_Name
)

SELECT *
FROM restaurant_stats
WHERE order_count < (
    SELECT AVG(order_count)
    FROM restaurant_stats
)
ORDER BY avg_order_value DESC;


/*
====================================================
Business Problem 11
====================================================

Business Problem:
Which food categories are most dependent on a single city for their revenue?

Business Value:
Revenue concentration analysis helps identify categories
that rely heavily on one market. High dependency may
indicate expansion opportunities as well as potential
business risk if demand in that city declines.

Business Insight from Output:
Several categories show 100% revenue dependency on a
single city. This may indicate that those categories are
currently available only in that particular city or have
very limited geographic presence. Expanding successful
niche categories into other cities could help diversify
revenue and reduce concentration risk.

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
- Window Functions
- ROW_NUMBER()
- Percentage Analysis
- Revenue Concentration Analysis
*/

WITH city_category_revenue AS (
    SELECT
        c.Category,
        l.City,
        SUM(f.Price_INR) AS revenue
    FROM fact_swiggy_orders f
    JOIN dim_category c
        ON c.category_id = f.category_id
    JOIN dim_location l
        ON l.location_id = f.location_id
    GROUP BY c.Category, l.City
),

category_total AS (
    SELECT
         Category,
         SUM(revenue) AS total_revenue
    FROM city_category_revenue
    GROUP BY Category
),

ranked AS (
    SELECT
         ccr.City,
         ccr.Category,
         ccr.revenue,
         ct.total_revenue,
         ROUND(
            ccr.revenue * 100.0 / ct.total_revenue,
            2
         ) AS revenue_pct,
         ROW_NUMBER() OVER(
             PARTITION BY ccr.Category
             ORDER BY ccr.revenue DESC
         ) AS rnk
    FROM city_category_revenue ccr
    JOIN category_total ct
    ON ccr.Category = ct.Category
)

SELECT
      Category,
      City,
      revenue,
      total_revenue,
      revenue_pct
FROM ranked
WHERE rnk = 1
ORDER BY revenue_pct DESC;


/*
====================================================
Business Problem 12
====================================================

Business Problem:
Which cities contribute the largest share of platform revenue?

Business Value:
Understanding revenue contribution by city helps identify
high-value markets, prioritize investment decisions,
optimize marketing spend, and support future expansion
strategies.

Business Insight from Output:
Bengaluru contributes the largest share of platform
revenue (10.29%), making it one of the most important
markets for revenue growth and customer acquisition.

Dataset:
Swiggy Data Warehouse

Schema:
Star Schema

Fact Table:
- fact_swiggy_orders

Dimension Tables:
- dim_location

SQL Concepts Used:
- CTE
- SUM()
- Subquery
- Percentage Contribution Analysis
- Revenue Analysis
*/

WITH city_revenue AS (
    SELECT
        l.City,
        SUM(f.Price_INR) AS revenue
    FROM fact_swiggy_orders f
    JOIN dim_location l
        ON l.location_id = f.location_id
    GROUP BY l.City
)

SELECT
    City,
    revenue,
    ROUND(
        revenue * 100.0 /
        (SELECT SUM(revenue) FROM city_revenue),
        2
    ) AS revenue_pct
FROM city_revenue
ORDER BY revenue_pct DESC;
