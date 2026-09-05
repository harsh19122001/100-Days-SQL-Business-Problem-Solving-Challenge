/*
====================================================
Business Problem 55
====================================================

Business Problem:
Which employment length groups have the highest average loan amount?

Business Value:
Helps identify whether borrowers with longer employment
histories tend to receive larger loans, providing insights
into lending patterns and borrower stability.

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
    emp_length,
    COUNT(*) AS total_loans,
    ROUND(AVG(loan_amount),2) AS avg_loan_amount
FROM finance_loan
WHERE emp_length IS NOT NULL
GROUP BY emp_length
ORDER BY avg_loan_amount DESC;


/*
====================================================
Business Problem 56
====================================================

Business Problem:
Which employment length groups have the lowest default rate?

Business Value:
Helps determine whether employment stability is linked
to better repayment behavior and lower lending risk.

Dataset:
Financial Loan Dataset

Table:
- finance_loan

SQL Concepts Used:
- CASE WHEN
- COUNT()
- GROUP BY
- Default Rate Analysis
*/

SELECT
    emp_length,
    COUNT(*) AS total_loans,
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
WHERE emp_length IS NOT NULL
GROUP BY emp_length
ORDER BY default_rate ASC;


/*
====================================================
Business Problem 57
====================================================

Business Problem:
Which grades have the highest average installment-to-loan ratio?

Business Value:
Measures repayment burden relative to loan size and
helps compare affordability across borrower credit grades.

Dataset:
Financial Loan Dataset

Table:
- finance_loan

SQL Concepts Used:
- AVG()
- Derived Metrics
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