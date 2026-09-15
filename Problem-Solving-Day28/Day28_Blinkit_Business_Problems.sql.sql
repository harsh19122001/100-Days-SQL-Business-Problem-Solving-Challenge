/*
====================================================
Business Problem 82
====================================================

Business Problem:
Which item types contribute the highest percentage
of sales within each outlet type?

Business Value:
Identifies the dominant product categories driving
revenue in different store formats.
*/

WITH item_metrics AS (
    SELECT
        Item_Type,
        AVG(Total_Sales) AS avg_sales,
        AVG(Rating) AS avg_rating
    FROM blinkit
    GROUP BY Item_Type
),

overall_metrics AS (
    SELECT
        AVG(Total_Sales) AS overall_avg_sales,
        AVG(Rating) AS overall_avg_rating
    FROM blinkit
)

SELECT
    im.Item_Type,
    ROUND(im.avg_sales,2) AS avg_sales,
    ROUND(im.avg_rating,2) AS avg_rating
FROM item_metrics im
CROSS JOIN overall_metrics om
WHERE im.avg_sales > om.overall_avg_sales
AND im.avg_rating > om.overall_avg_rating
ORDER BY im.avg_rating DESC, im.avg_sales DESC;


/*
====================================================
Business Problem 83
====================================================

Business Problem:
Which outlet sizes generate the highest sales
per unique product?

Business Value:
Measures assortment productivity across outlet sizes.
*/

SELECT
    Outlet_Size,
    ROUND(
        SUM(Total_Sales) /
        COUNT(DISTINCT Item_Identifier),
        2
    ) AS sales_per_product
FROM blinkit
GROUP BY Outlet_Size
ORDER BY sales_per_product DESC;


/*
====================================================
Business Problem 84
====================================================

Business Problem:
Which item types achieve the highest average rating
while maintaining above-average sales?

Business Value:
Identifies product categories that are both customer
favorites and strong revenue contributors.
*/

WITH item_metrics AS (
    SELECT
        Item_Type,
        AVG(Total_Sales) AS avg_sales,
        AVG(Rating) AS avg_rating
    FROM blinkit
    GROUP BY Item_Type
)

SELECT
    Item_Type,
    ROUND(avg_sales,2) AS avg_sales,
    ROUND(avg_rating,2) AS avg_rating
FROM item_metrics
WHERE avg_sales >
(
    SELECT AVG(Total_Sales)
    FROM blinkit
)
ORDER BY avg_rating DESC;
