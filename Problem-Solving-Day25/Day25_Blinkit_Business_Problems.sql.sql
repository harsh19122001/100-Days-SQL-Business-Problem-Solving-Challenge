/*
====================================================
Business Problem 73
====================================================

Business Problem:
Which outlet types have the most diversified product portfolio?

Business Value:
Helps identify store formats offering the widest
product variety, improving customer choice and
cross-selling opportunities.
*/

SELECT
    Outlet_Type,
    COUNT(DISTINCT Item_Type) AS unique_item_types
FROM blinkit
GROUP BY Outlet_Type
ORDER BY unique_item_types DESC;


/*
====================================================
Business Problem 74
====================================================

Business Problem:
Which item types generate high sales despite having
below-average visibility?

Business Value:
Identifies products that sell well even with lower
exposure, indicating strong customer demand.
*/

WITH item_metrics AS (
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
    im.Item_Type,
    ROUND(im.avg_visibility,4) AS avg_visibility,
    ROUND(im.avg_sales,2) AS avg_sales
FROM item_metrics im
CROSS JOIN overall_metrics om
WHERE im.avg_visibility < om.overall_visibility
AND im.avg_sales > om.overall_sales
ORDER BY im.avg_sales DESC;


/*
====================================================
Business Problem 75
====================================================

Business Problem:
Which outlet sizes achieve the highest sales per item type offered?

Business Value:
Measures how efficiently different outlet sizes
convert product assortment into revenue.
*/

SELECT
    Outlet_Size,
    ROUND(
        SUM(Total_Sales) /
        COUNT(DISTINCT Item_Type),
        2
    ) AS sales_per_item_type
FROM blinkit
GROUP BY Outlet_Size
ORDER BY sales_per_item_type DESC;