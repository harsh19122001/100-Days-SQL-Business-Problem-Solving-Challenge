/*
====================================================
Business Problem 70
====================================================

Business Problem:
Which outlet types generate the highest sales per outlet?

Business Value:
Measures outlet efficiency instead of total sales,
helping identify the most productive store formats.
*/

SELECT
    Outlet_Type,
    COUNT(DISTINCT Outlet_Identifier) AS total_outlets,
    ROUND(
        SUM(Total_Sales) /
        COUNT(DISTINCT Outlet_Identifier),
        2
    ) AS sales_per_outlet
FROM blinkit
GROUP BY Outlet_Type
ORDER BY sales_per_outlet DESC;


/*
====================================================
Business Problem 71
====================================================

Business Problem:
Which item types have high visibility but low average sales?

Business Value:
Identifies products receiving strong exposure but
failing to convert into sales, highlighting possible
assortment or pricing issues.
*/

WITH item_performance AS (
    SELECT
        Item_Type,
        AVG(Item_Visibility) AS avg_visibility,
        AVG(Total_Sales) AS avg_sales
    FROM blinkit
    GROUP BY Item_Type
),

overall_metrics AS (
    SELECT
        AVG(Item_Visibility) AS overall_visibility,
        AVG(Total_Sales) AS overall_sales
    FROM blinkit
)

SELECT
    ip.Item_Type,
    ROUND(ip.avg_visibility,4) AS avg_visibility,
    ROUND(ip.avg_sales,2) AS avg_sales
FROM item_performance ip
CROSS JOIN overall_metrics om
WHERE ip.avg_visibility > om.overall_visibility
AND ip.avg_sales < om.overall_sales
ORDER BY ip.avg_visibility DESC;


/*
====================================================
Business Problem 72
====================================================

Business Problem:
Which outlet establishment years have the highest
average customer ratings?

Business Value:
Evaluates whether newer or older outlets provide
better customer experiences and satisfaction.
*/

SELECT
    Outlet_Establishment_Year,
    COUNT(DISTINCT Outlet_Identifier) AS total_outlets,
    ROUND(AVG(Rating),2) AS avg_rating
FROM blinkit
GROUP BY Outlet_Establishment_Year
ORDER BY avg_rating DESC;