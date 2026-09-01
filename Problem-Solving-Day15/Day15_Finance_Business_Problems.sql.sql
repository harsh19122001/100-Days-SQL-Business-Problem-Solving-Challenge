/*
====================================================
Business Problem 43
====================================================

Business Problem:
Which loan purposes have the highest average interest rate
but the lowest default rate?

Business Value:
Identifies loan categories that generate strong returns
while maintaining relatively low credit risk, helping
lenders optimize portfolio profitability.

Dataset:
Financial Loan Dataset

Table:
- finance_loan

SQL Concepts Used:
- CTEs
- AVG()
- CASE WHEN
- Aggregations
- Risk vs Profitability Analysis
*/

WITH purpose_analysis AS (
    SELECT
        purpose,
        ROUND(AVG(int_rate),2) AS avg_interest_rate,
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
    FROM finance_loan
    GROUP BY purpose
)

SELECT
    purpose,
    avg_interest_rate,
    default_rate
FROM purpose_analysis
ORDER BY avg_interest_rate DESC,
         default_rate ASC;


/*
====================================================
Business Problem 44
====================================================

Business Problem:
Which states have the highest average loan amount and repayment amount?

Business Value:
Identifies regions where borrowers receive and repay
larger loans, helping lenders evaluate market opportunities
and customer borrowing behavior.

Dataset:
Financial Loan Dataset

Table:
- finance_loan

SQL Concepts Used:
- AVG()
- GROUP BY
- Geographic Analysis
- Lending Analytics
*/

SELECT
    address_state,
    ROUND(AVG(loan_amount),2) AS avg_loan_amount,
    ROUND(AVG(total_payment),2) AS avg_repayment_amount
FROM finance_loan
GROUP BY address_state
ORDER BY avg_loan_amount DESC;


/*
====================================================
Business Problem 45
====================================================

Business Problem:
Which grades experience the highest loss from charged-off loans?

Business Value:
Measures portfolio losses across credit grades and helps
identify borrower segments contributing most to lending risk.

Dataset:
Financial Loan Dataset

Table:
- finance_loan

SQL Concepts Used:
- SUM()
- COUNT()
- GROUP BY
- Credit Risk Analysis
- Portfolio Loss Analysis
*/

SELECT
    grade,
    COUNT(*) AS charged_off_loans,
    ROUND(
        SUM(loan_amount),
        2
    ) AS charged_off_loan_amount
FROM finance_loan
WHERE loan_status = 'Charged Off'
GROUP BY grade
ORDER BY charged_off_loan_amount DESC;