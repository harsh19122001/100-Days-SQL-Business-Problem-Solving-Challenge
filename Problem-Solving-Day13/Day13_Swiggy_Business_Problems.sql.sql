/*
====================================================
Business Problem 37
====================================================

Business Problem:
Which loan purposes generate the highest interest income?

Business Value:
Identifies which borrowing purposes contribute the
most revenue to the lending business and helps evaluate
portfolio profitability.

Dataset:
Financial Loan Dataset

Table:
- finance_data

SQL Concepts Used:
- SUM()
- GROUP BY
- Revenue Analysis
- Profitability Analysis
*/

SELECT
    purpose,
    ROUND(
        SUM(total_payment - loan_amount),
        2
    ) AS high_interest_income
FROM finance_data
GROUP BY purpose
ORDER BY high_interest_income DESC;


/*
====================================================
Business Problem 38
====================================================

Business Problem:
Which verification status groups have the lowest default rate?

Business Value:
Evaluates whether income verification helps reduce
credit risk and improves lending quality.

Dataset:
Financial Loan Dataset

Table:
- finance_data

SQL Concepts Used:
- CASE WHEN
- COUNT()
- SUM()
- GROUP BY
- Risk Analysis
*/

SELECT
    verification_status,
    ROUND(
        SUM(
            CASE
                WHEN loan_status = 'Charged Off'
                THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS default_rate
FROM finance_data
GROUP BY verification_status
ORDER BY default_rate ASC;


/*
====================================================
Business Problem 39
====================================================

Business Problem:
Which grades have the highest average interest rate?

Business Value:
Shows how loan pricing varies across borrower credit
grades and helps understand risk-based lending strategies.

Dataset:
Financial Loan Dataset

Table:
- finance_data

SQL Concepts Used:
- AVG()
- GROUP BY
- Pricing Analysis
- Lending Analytics
*/

SELECT
    grade,
    ROUND(
        AVG(int_rate),
        2
    ) AS avg_interest_rate
FROM finance_data
GROUP BY grade
ORDER BY avg_interest_rate DESC;
     