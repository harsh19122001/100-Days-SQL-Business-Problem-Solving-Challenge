/*
====================================================
Business Problem 61
====================================================

Business Problem:
Which item types generate the highest average sales per product?

Business Value:
Helps identify product categories that consistently
generate higher revenue and can be prioritized for
inventory planning and promotions.
*/

SELECT
    Item_Type,
    COUNT(*) AS total_products,
    ROUND(AVG(Total_Sales),2) AS avg_sales
FROM blinkit
GROUP BY Item_Type
ORDER BY avg_sales DESC;


/*
====================================================
Business Problem 62
====================================================

Business Problem:
Which outlet sizes achieve the highest average customer rating?

Business Value:
Evaluates customer satisfaction across different
store sizes and helps identify the most effective
retail format.
*/

SELECT
    Outlet_Size,
    COUNT(*) AS total_products,
    ROUND(AVG(Rating),2) AS avg_rating
FROM blinkit
GROUP BY Outlet_Size
ORDER BY avg_rating DESC;


/*
====================================================
Business Problem 63
====================================================

Business Problem:
Which outlet location types generate the highest average sales?

Business Value:
Helps understand location performance and supports
future expansion and store placement decisions.
*/

SELECT
    Outlet_Location_Type,
    COUNT(*) AS total_products,
    ROUND(AVG(Total_Sales),2) AS avg_sales
FROM blinkit
GROUP BY Outlet_Location_Type
ORDER BY avg_sales DESC;