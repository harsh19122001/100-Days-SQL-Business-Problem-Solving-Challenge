/*
====================================================
Business Problem 52
====================================================

Business Problem:
Which sub-grades generate the highest average interest income per loan?

Business Value:
Identifies borrower segments contributing the most
profit per loan and helps optimize pricing strategies.
*/

SELECT
    sub_grade,
    ROUND(
        AVG(total_payment - loan_amount),
        2
    ) AS avg_interest_income
FROM finance_loan
GROUP BY sub_grade
ORDER BY avg_interest_income DESC;


/*
====================================================
Business Problem 53
====================================================

Business Problem:
Which verification status groups have the highest average debt-to-income ratio?

Business Value:
Helps evaluate whether verified borrowers carry
higher or lower debt burdens compared to other groups.
*/

SELECT
    verification_status,
    ROUND(
        AVG(dti),
        2
    ) AS avg_dti
FROM finance_loan
GROUP BY verification_status
ORDER BY avg_dti DESC;


/*
====================================================
Business Problem 54
====================================================

Business Problem:
Which home ownership categories have the highest average interest rate?

Business Value:
Analyzes how loan pricing varies across different
housing ownership segments.
*/

SELECT
    home_ownership,
    ROUND(
        AVG(int_rate),
        2
    ) AS avg_interest_rate
FROM finance_loan
GROUP BY home_ownership
ORDER BY avg_interest_rate DESC;