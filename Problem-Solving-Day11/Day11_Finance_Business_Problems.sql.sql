/*
====================================================
Business Problem 31
====================================================

Business Problem:
Which loan purposes have the highest default rate?

Business Value:
Identifies the riskiest loan purposes and helps lenders
improve approval policies, risk management, and credit
decision-making.

Dataset:
Financial Loan Dataset

Table:
- financial_loan

SQL Concepts Used:
- CASE WHEN
- SUM()
- COUNT()
- GROUP BY
- Risk Analysis
*/

SELECT
    purpose,
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
GROUP BY purpose
ORDER BY default_rate DESC;


/*
====================================================
Business Problem 32
====================================================

Business Problem:
Which loan grades generate the highest total repayment amount?

Business Value:
Measures which borrower grades contribute the most
recovered capital and overall portfolio performance.

Dataset:
Financial Loan Dataset

Table:
- financial_loan

SQL Concepts Used:
- SUM()
- GROUP BY
- Financial Analysis
- Ranking
*/

SELECT
    grade,
    SUM(total_payment) AS total_repayment
FROM finance_data
GROUP BY grade
ORDER BY total_repayment DESC;


/*
====================================================
Business Problem 33
====================================================

Business Problem:
Which states have the highest percentage of charged-off loans?

Business Value:
Helps identify geographic regions with elevated credit
risk and supports region-specific lending strategies.

Dataset:
Financial Loan Dataset

Table:
- financial_loan

SQL Concepts Used:
- CASE WHEN
- AVG()
- GROUP BY
- Risk Segmentation
*/

SELECT
    address_state,
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
    ) AS charged_off_percentage
FROM finance_data
GROUP BY address_state
ORDER BY charged_off_percentage DESC;