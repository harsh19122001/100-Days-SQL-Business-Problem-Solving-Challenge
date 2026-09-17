/*
====================================================
Business Problem 85
====================================================

Business Problem:
Which outlet types generate the highest average sales
for highly visible products?

Business Value:
Determines which outlet formats are most effective
at converting highly exposed products into revenue.
*/

SELECT
    Outlet_Type,
    ROUND(AVG(Total_Sales),2) AS avg_sales
FROM blinkit
WHERE Item_Visibility >
(
    SELECT AVG(Item_Visibility)
    FROM blinkit
)
GROUP BY Outlet_Type
ORDER BY avg_sales DESC;


/*
====================================================
Business Problem 86
====================================================

Business Problem:
Which item types have the largest gap between
their average rating and overall average rating?

Business Value:
Identifies categories that significantly outperform
or underperform customer expectations.
*/

WITH item_rating AS (
    SELECT
        Item_Type,
        AVG(Rating) AS avg_rating
    FROM blinkit
    GROUP BY Item_Type
),

overall_rating AS (
    SELECT
        AVG(Rating) AS company_rating
    FROM blinkit
)

SELECT
    ir.Item_Type,
    ROUND(ir.avg_rating,2) AS avg_rating,
    ROUND(or1.company_rating,2) AS company_rating,
    ROUND(
        ABS(ir.avg_rating - or1.company_rating),
        2
    ) AS rating_gap
FROM item_rating ir
CROSS JOIN overall_rating or1
ORDER BY rating_gap DESC;


/*
====================================================
Business Problem 87
====================================================

Business Problem:
Which outlet locations contribute the highest share
of total company sales?

Business Value:
Helps identify the most important geographical
segments driving overall business revenue.
*/

WITH location_sales AS (
    SELECT
        Outlet_Location_Type,
        SUM(Total_Sales) AS sales
    FROM blinkit
    GROUP BY Outlet_Location_Type
)

SELECT
    Outlet_Location_Type,
    sales,
    ROUND(
        sales * 100.0 /
        (SELECT SUM(sales) FROM location_sales),
        2
    ) AS contribution_percentage
FROM location_sales
ORDER BY contribution_percentage DESC;
