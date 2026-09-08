/*
====================================================
Business Problem 64
====================================================

Business Problem:
Which item types contribute the highest percentage
of total company sales?

Business Value:
Identifies product categories driving overall business
revenue and helps prioritize inventory investment.
*/

WITH item_sales AS (
    SELECT
        Item_Type,
        SUM(Total_Sales) AS sales
    FROM blinkit_data
    GROUP BY Item_Type
)

SELECT
    Item_Type,
    sales,
    ROUND(
        sales * 100.0 /
        (SELECT SUM(sales) FROM item_sales),
        2
    ) AS sales_percentage
FROM item_sales
ORDER BY sales_percentage DESC;


/*
====================================================
Business Problem 65
====================================================

Business Problem:
Which outlet types generate high sales despite
having lower customer ratings?

Business Value:
Helps identify stores performing well commercially
but potentially facing customer satisfaction issues.
*/

SELECT
    Outlet_Type,
    ROUND(AVG(Total_Sales),2) AS avg_sales,
    ROUND(AVG(Rating),2) AS avg_rating
FROM blinkit_data
GROUP BY Outlet_Type
ORDER BY avg_sales DESC;


/*
====================================================
Business Problem 66
====================================================

Business Problem:
Which outlet establishment years continue to
generate the highest average sales?

Business Value:
Measures long-term outlet performance and helps
understand whether older stores outperform newer stores.
*/

SELECT
    Outlet_Establishment_Year,
    COUNT(DISTINCT Outlet_Identifier) AS total_outlets,
    ROUND(AVG(Total_Sales),2) AS avg_sales
FROM blinkit_data
GROUP BY Outlet_Establishment_Year
ORDER BY avg_sales DESC;