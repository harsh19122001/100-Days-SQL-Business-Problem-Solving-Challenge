/*
====================================================
Business Problem 79
====================================================

Business Problem:
Which item types generate the highest sales per unit
of visibility?

Business Value:
Identifies products that convert visibility into
sales most efficiently, helping optimize shelf
placement and marketing exposure.
*/

SELECT
    Item_Type,
    ROUND(
        SUM(Total_Sales) /
        NULLIF(SUM(Item_Visibility),0),
        2
    ) AS sales_per_visibility
FROM blinkit
GROUP BY Item_Type
ORDER BY sales_per_visibility DESC;


/*
====================================================
Business Problem 80
====================================================


Business Problem:
Which outlet types maintain above-average ratings
and above-average sales simultaneously?

Business Value:
Identifies high-performing outlet formats that
successfully balance customer satisfaction and
revenue generation.

Dataset:
Blinkit Grocery Sales Dataset
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
        AVG(Total_Sales) AS overall_sales,
        AVG(Rating) AS overall_rating
    FROM blinkit
)

SELECT
    im.Item_Type,
    ROUND(im.avg_sales,2) AS avg_sales,
    ROUND(im.avg_rating,2) AS avg_rating
FROM item_metrics im
CROSS JOIN overall_metrics om
WHERE im.avg_sales > om.overall_sales
AND im.avg_rating > om.overall_rating
ORDER BY avg_sales DESC;


/*
====================================================
Business Problem 81
====================================================

Business Problem:
Which outlet establishment years show the most
consistent sales performance?

Business Value:
Helps identify store generations with stable
performance and lower revenue volatility.
*/

