/*
====================================================
Business Problem 25
====================================================

Business Problem:
Which restaurants have the highest month-over-month revenue growth?

Business Value:
Identifying restaurants with strong month-over-month
revenue growth helps uncover emerging top performers,
successful business strategies, and potential expansion
opportunities within the platform.

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
- LAG()
- Window Functions
- Revenue Analysis
- Growth Analysis
*/

WITH restaurant_monthly_revenue AS(
    SELECT
        r.Restaurant_Name,
        d.Year,
        d.Month,
        SUM(f.Price_INR) AS revenue
    FROM fact_swiggy_orders f
    JOIN dim_date d
        ON d.date_id = f.date_id
    JOIN dim_restaurant r
        ON r.restaurant_id = f.restaurant_id
    GROUP BY
        r.Restaurant_Name,
        d.Year,
        d.Month
),

last_month AS(
    SELECT
        Restaurant_Name,
        Year,
        Month,
        revenue AS current_month_revenue,
        LAG(revenue) OVER(
            PARTITION BY Restaurant_Name
            ORDER BY Year, Month
        ) AS previous_month_revenue
    FROM restaurant_monthly_revenue
),

monthly_growth AS(
    SELECT
        Restaurant_Name,
        Year,
        Month,
        current_month_revenue,
        previous_month_revenue,
        ROUND(
            ((current_month_revenue - previous_month_revenue) * 100)
            / previous_month_revenue,
            2
        ) AS growth_percentage
    FROM last_month
    WHERE previous_month_revenue IS NOT NULL
)

SELECT
    Restaurant_Name,
    Year,
    Month,
    previous_month_revenue,
    current_month_revenue,
    growth_percentage
FROM monthly_growth
ORDER BY growth_percentage DESC
LIMIT 10;



/*
====================================================
Business Problem 26
====================================================

Business Problem:
Which cities have the most stable customer ratings over time?

Business Value:
Consistently high customer satisfaction is often more
valuable than occasional peaks. Identifying cities with
stable ratings helps evaluate service quality and
customer experience consistency.

Dataset:
Swiggy Data Warehouse

Schema:
Star Schema

Fact Table:
- fact_swiggy_orders

Dimension Tables:
- dim_location
- dim_date

SQL Concepts Used:
- CTE
- AVG()
- STDDEV()
- GROUP BY
- Stability Analysis
*/

WITH monthly_city_rating AS (
    SELECT
        l.City,
        d.Year,
        d.Month,
        AVG(f.Rating) AS avg_monthly_rating
    FROM fact_swiggy_orders f
    JOIN dim_location l
        ON l.location_id = f.location_id
    JOIN dim_date d
        ON d.date_id = f.date_id
    GROUP BY
        l.City,
        d.Year,
        d.Month
),

city_rating_stability AS (
    SELECT
        City,
        ROUND(
            STDDEV(avg_monthly_rating),
            4
        ) AS rating_stddev
    FROM monthly_city_rating
    GROUP BY City
)

SELECT
    City,
    rating_stddev
FROM city_rating_stability
ORDER BY rating_stddev ASC;



/*
====================================================
Business Problem 27
====================================================

Business Problem:
Which restaurants maintain consistently high revenue across multiple months?

Business Value:
High revenue in a single month can be driven by
temporary factors, while consistently strong revenue
across months indicates sustainable business performance
and strong customer demand.

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
- Revenue Consistency Analysis
*/

WITH monthly_restaurant_revenue AS (
    SELECT
        r.Restaurant_Name,
        d.Year,
        d.Month,
        SUM(f.Price_INR) AS revenue
    FROM fact_swiggy_orders f
    JOIN dim_restaurant r
        ON r.restaurant_id = f.restaurant_id
    JOIN dim_date d
        ON d.date_id = f.date_id
    GROUP BY
        r.Restaurant_Name,
        d.Year,
        d.Month
),

avg_monthly_revenue AS (
    SELECT
        AVG(revenue) AS avg_revenue
    FROM monthly_restaurant_revenue
)

SELECT
    mrr.Restaurant_Name,
    ROUND(AVG(mrr.revenue),2) AS avg_revenue,
    ROUND(MIN(mrr.revenue),2) AS lowest_monthly_revenue
FROM monthly_restaurant_revenue mrr
GROUP BY mrr.Restaurant_Name
HAVING MIN(mrr.revenue) >
(
    SELECT avg_revenue
    FROM avg_monthly_revenue
)
ORDER BY avg_revenue DESC;