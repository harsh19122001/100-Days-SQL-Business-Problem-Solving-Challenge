/*
====================================================
Business Problem 46
====================================================

Business Problem:
Which loan purposes have the highest average debt-to-income ratio?

Business Value:
Identifies loan categories where borrowers carry
higher debt burdens, helping lenders assess risk
before loan approval.

Dataset:
Financial Loan Dataset

Table:
- finance_loan

SQL Concepts Used:
- AVG()
- GROUP BY
- Risk Analysis
*/

SELECT
    purpose,
    ROUND(AVG(dti),2) AS avg_dti
FROM finance_loan
GROUP BY purpose
ORDER BY avg_dti DESC;


/*
====================================================
Business Problem 47
====================================================

Business Problem:
Which states have the highest percentage of fully paid loans?

Business Value:
Helps identify geographic regions with stronger
repayment behavior and lower credit risk.

Dataset:
Financial Loan Dataset

Table:
- finance_loan

SQL Concepts Used:
- CASE WHEN
- COUNT()
- GROUP BY
- Repayment Analysis
*/

SELECT
    address_state,

    COUNT(*) AS total_loans,

    SUM(
        CASE
            WHEN loan_status = 'Fully Paid'
            THEN 1
            ELSE 0
        END
    ) AS fully_paid_loans,

    ROUND(
        SUM(
            CASE
                WHEN loan_status = 'Fully Paid'
                THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS fully_paid_percentage

FROM finance_loan
GROUP BY address_state
ORDER BY fully_paid_percentage DESC;


/*
====================================================
Business Problem 48
====================================================

Business Problem:
Which grades have the highest average annual income
but still experience loan defaults?

Business Value:
Identifies whether high-income borrowers are always
lower risk and helps uncover hidden credit risk
within premium customer segments.

Dataset:
Financial Loan Dataset

Table:
- finance_loan

SQL Concepts Used:
- AVG()
- CASE WHEN
- GROUP BY
- Customer Risk Analysis
*/

SELECT
    grade,

    COUNT(*) AS charged_off_loans,

    ROUND(
        AVG(annual_income),
        2
    ) AS avg_annual_income

FROM finance_loan
WHERE loan_status = 'Charged Off'
GROUP BY grade
ORDER BY avg_annual_income DESC;