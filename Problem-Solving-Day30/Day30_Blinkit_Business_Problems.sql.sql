/*
====================================================
Business Problem 88
====================================================

Business Problem:
Which item types are available across the highest
number of outlets?

Business Value:
Identifies products with the widest distribution
across the retail network.
*/



/*
====================================================
Business Problem 89
====================================================

Business Problem:
Which outlet types have the highest average
item visibility?

Business Value:
Helps understand which store formats provide
better product exposure.
*/

SELECT
    Outlet_Type,
    ROUND(AVG(Item_Visibility),4) AS avg_visibility
FROM blinkit
GROUP BY Outlet_Type
ORDER BY avg_visibility DESC;


/*
====================================================
Business Problem 90
====================================================

Business Problem:
Which item types generate the highest sales
per outlet where they are sold?

Business Value:
Measures category productivity after adjusting
for outlet coverage.
*/

WITH item_sales AS (
    SELECT
        Item_Type,
        SUM(Total_Sales) AS total_sales,
        COUNT(DISTINCT Outlet_Identifier) AS outlet_count
    FROM blinkit
    GROUP BY Item_Type
)

SELECT
    Item_Type,
    ROUND(total_sales,2) AS total_sales,
    outlet_count,
    ROUND(
        total_sales / outlet_count,
        2
    ) AS sales_per_outlet
FROM item_sales
ORDER BY sales_per_outlet DESC;