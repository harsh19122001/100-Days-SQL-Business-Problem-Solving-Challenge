/*
====================================================
Business Problem 67
====================================================

Business Problem:
Which item types perform significantly better than
their category average sales?

Business Value:
Helps identify star-performing product categories
that outperform their peers and deserve additional
inventory and promotion investment.
*/




/*
====================================================
Business Problem 68
====================================================

Business Problem:
Which outlet types have the highest dependence on
Low Fat products?

Business Value:
Helps understand customer buying preferences across
store formats and supports assortment planning.
*/

SELECT
    Outlet_Type,
    ROUND(
        SUM(
            CASE
                WHEN Item_Fat_Content = 'Low Fat'
                THEN Total_Sales
                ELSE 0
            END
        ) * 100.0 /
        SUM(Total_Sales),
        2
    ) AS low_fat_sales_percentage
FROM blinkit
GROUP BY Outlet_Type
ORDER BY low_fat_sales_percentage DESC;


/*
====================================================
Business Problem 69
====================================================

Business Problem:
Which outlet locations have the highest concentration
of top-rated products?

Business Value:
Identifies regions delivering better customer
satisfaction and product performance.
*/

WITH location_rating AS (
    SELECT
        Outlet_Location_Type,
        AVG(Rating) AS avg_rating
    FROM blinkit
    GROUP BY Outlet_Location_Type
)

SELECT
    Outlet_Location_Type,
    ROUND(avg_rating,2) AS avg_rating
FROM location_rating
ORDER BY avg_rating DESC;