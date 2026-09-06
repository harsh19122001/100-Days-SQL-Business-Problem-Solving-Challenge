/*
====================================================
Business Problem 58
====================================================

Business Problem:
Which sub-grades have the highest average loan amount?

Business Value:
Identifies borrower segments receiving larger loans
and helps understand lending exposure at a granular
credit-risk level.
*/

SELECT
    sub_grade,
    COUNT(*) AS total_loans,
    ROUND(AVG(loan_amount),2) AS avg_loan_amount
FROM finance_loan
GROUP BY sub_grade
ORDER BY avg_loan_amount DESC;


/*
====================================================
Business Problem 59
====================================================

Business Problem:
Which verification status groups generate the highest average interest income per loan?

Business Value:
Helps evaluate whether borrower verification quality
is associated with higher portfolio profitability.
*/

SELECT
    verification_status,
    COUNT(*) AS total_loans,
    ROUND(
        AVG(total_payment - loan_amount),
        2
    ) AS avg_interest_income
FROM finance_loan
GROUP BY verification_status
ORDER BY avg_interest_income DESC;


/*
====================================================
Business Problem 60
====================================================

Business Problem:
Which home ownership categories have the highest average annual income?

Business Value:
Provides insight into borrower financial strength
across housing ownership segments.
*/

SELECT
    home_ownership,
    COUNT(*) AS total_borrowers,
    ROUND(
        AVG(annual_income),
        2
    ) AS avg_annual_income
FROM finance_loan
GROUP BY home_ownership
ORDER BY avg_annual_income DESC;