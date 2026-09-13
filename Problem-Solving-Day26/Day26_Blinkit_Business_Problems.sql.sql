/*
====================================================
Business Problem 76
====================================================

Business Problem:
Which item types receive higher ratings despite
generating below-average sales?

Business Value:
Identifies products that customers love but are
currently underperforming in revenue, creating
promotion opportunities.
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
WHERE im.avg_sales < om.overall_sales
AND im.avg_rating > om.overall_rating
ORDER BY im.avg_rating DESC;


/*
====================================================
Business Problem 77
====================================================

Business Problem:
Which outlet locations generate high sales but
below-average customer ratings?

Business Value:
Identifies locations where revenue is strong but
customer experience may need improvement.
*/

WITH location_metrics AS (
    SELECT
        Outlet_Location_Type,
        AVG(Total_Sales) AS avg_sales,
        AVG(Rating) AS avg_rating
    FROM blinkit
    GROUP BY Outlet_Location_Type
),

overall_metrics AS (
    SELECT
        AVG(Total_Sales) AS overall_sales,
        AVG(Rating) AS overall_rating
    FROM blinkit
)

SELECT
    lm.Outlet_Location_Type,
    ROUND(lm.avg_sales,2) AS avg_sales,
    ROUND(lm.avg_rating,2) AS avg_rating
FROM location_metrics lm
CROSS JOIN overall_metrics om
WHERE lm.avg_sales > om.overall_sales
AND lm.avg_rating < om.overall_rating
ORDER BY lm.avg_sales DESC;


/*
====================================================
Business Problem 78
====================================================

Business Problem:
Which outlet types generate the highest revenue
per unique item sold?

Business Value:
Measures assortment efficiency and identifies
store formats extracting maximum value from
their product portfolio.
*/

SELECT
    Outlet_Type,
    ROUND(
        SUM(Total_Sales) /
        COUNT(DISTINCT Item_Identifier),
        2
    ) AS revenue_per_item
FROM blinkit
GROUP BY Outlet_Type
ORDER BY revenue_per_item DESC;