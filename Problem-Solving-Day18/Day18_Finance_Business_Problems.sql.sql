/*
====================================================
Business Problem 55
====================================================

Business Problem:
Which employment length groups receive the highest average interest rates?

Business Value:
Helps understand whether borrowers with different
employment histories are being priced differently
based on perceived credit risk.

Dataset:
Financial Loan Dataset

Table:
- finance_loan

SQL Concepts Used:
- AVG()
- GROUP BY
- Lending Pricing Analysis
*/

SELECT
    emp_length,
    COUNT(*) AS total_loans,
    ROUND(AVG(int_rate),2) AS avg_interest_rate
FROM finance_loan
WHERE emp_length IS NOT NULL
GROUP BY emp_length
ORDER BY avg_interest_rate DESC;


/*
====================================================
Business Problem 56
====================================================

Business Problem:
Which application types generate the highest average loan amount?

Business Value:
Compares borrowing behavior between application
channels and identifies segments driving larger loans.

Dataset:
Financial Loan Dataset

Table:
- finance_loan

SQL Concepts Used:
- AVG()
- COUNT()
- GROUP BY
- Customer Segmentation
*/

SELECT
    application_type,
    COUNT(*) AS total_loans,
    ROUND(AVG(loan_amount),2) AS avg_loan_amount
FROM finance_loan
GROUP BY application_type
ORDER BY avg_loan_amount DESC;


/*
====================================================
Business Problem 57
====================================================

Business Problem:
Which grades have the highest average installment-to-loan ratio?

Business Value:
Measures repayment burden relative to loan size and
helps compare affordability across borrower grades.

Dataset:
Financial Loan Dataset

Table:
- finance_loan

SQL Concepts Used:
- Derived Metrics
- AVG()
- GROUP BY
- Lending Analysis
*/

SELECT
    grade,
    ROUND(
        AVG((installment * 100.0) / loan_amount),
        2
    ) AS installment_to_loan_ratio
FROM finance_loan
GROUP BY grade
ORDER BY installment_to_loan_ratio DESC;