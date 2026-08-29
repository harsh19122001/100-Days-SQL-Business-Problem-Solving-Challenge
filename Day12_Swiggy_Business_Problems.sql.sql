/*
====================================================
Business Problem 34
====================================================

Business Problem:
Which employment length groups have the highest average loan amount?

Business Value:
Analyzes whether borrowers with longer employment
histories tend to receive larger loans, helping lenders
understand borrower stability and lending patterns.

Dataset:
Financial Loan Dataset

Table:
- finance_data

SQL Concepts Used:
- AVG()
- COUNT()
- GROUP BY
- Customer Segmentation
*/

SELECT
    emp_length,
    COUNT(*) AS total_loans,
    ROUND(AVG(loan_amount)) AS avg_loan_amount
FROM finance_data
WHERE emp_length IS NOT NULL
GROUP BY emp_length
ORDER BY avg_loan_amount DESC;


/*
====================================================
Business Problem 35
====================================================

Business Problem:
Which home ownership categories have the highest default rate?

Business Value:
Identifies whether renters, homeowners, or borrowers
with mortgages present higher credit risk and helps
improve lending decisions.

Dataset:
Financial Loan Dataset

Table:
- finance_data

SQL Concepts Used:
- CASE WHEN
- SUM()
- COUNT()
- GROUP BY
- Risk Analysis
*/

SELECT
    home_ownership,
    COUNT(*) AS total_loans,
    SUM(
        CASE
            WHEN loan_status = 'Charged Off'
            THEN 1
            ELSE 0
        END
    ) AS charged_off_loans,
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
GROUP BY home_ownership
ORDER BY default_rate DESC;


/*
====================================================
Business Problem 36
====================================================

Business Problem:
Which loan terms generate the highest interest income?

Business Value:
Evaluates whether shorter-term or longer-term loans
contribute more interest revenue to the lending portfolio
and overall profitability.

Dataset:
Financial Loan Dataset

Table:
- finance_data

SQL Concepts Used:
- SUM()
- GROUP BY
- Financial Analysis
- Profitability Analysis
*/

SELECT
    term_months,
    ROUND(
        SUM(total_payment - loan_amount),
        2
    ) AS total_interest_income
FROM finance_data
GROUP BY term_months
ORDER BY total_interest_income DESC;