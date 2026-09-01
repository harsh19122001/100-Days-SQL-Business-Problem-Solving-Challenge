/*
====================================================
Business Problem 40
====================================================

Business Problem:
Which loan purposes have the highest default rate within each grade?

Business Value:
Identifies the riskiest loan purposes within every credit
grade, helping lenders refine approval strategies and
improve portfolio risk management.

Dataset:
Financial Loan Dataset

Table:
- finance_loan

SQL Concepts Used:
- CTEs
- CASE WHEN
- Aggregations
- Window Functions (RANK)
- Risk Analysis
*/

WITH purpose_stats AS (
    SELECT
        purpose,
        grade,
        (
            COUNT(
                CASE
                    WHEN loan_status = 'Charged Off'
                    THEN id
                END
            ) * 100.0 / COUNT(id)
        ) AS default_rate
    FROM finance_loan
    GROUP BY purpose, grade
),

ranked_purposes AS (
    SELECT
        purpose,
        grade,
        default_rate,
        RANK() OVER (
            PARTITION BY grade
            ORDER BY default_rate DESC
        ) AS rnk
    FROM purpose_stats
)

SELECT
    purpose,
    grade,
    ROUND(default_rate, 2) AS default_rate
FROM ranked_purposes
WHERE rnk = 1
ORDER BY default_rate DESC;


/*
====================================================
Business Problem 41
====================================================

Business Problem:
Which states generate high interest income but also have high default rates?

Business Value:
Highlights regions that deliver strong profitability
but also carry elevated lending risk, supporting
risk-adjusted lending decisions.

Dataset:
Financial Loan Dataset

Table:
- finance_loan

SQL Concepts Used:
- CTEs
- CASE WHEN
- Aggregations
- Subqueries
- Risk vs Return Analysis
*/

WITH state_analysis AS (
    SELECT
        address_state,
        SUM(total_payment - loan_amount) AS interest_income,
        COUNT(
            CASE
                WHEN loan_status = 'Charged Off'
                THEN id
            END
        ) * 100.0 / COUNT(*) AS default_rate
    FROM finance_loan
    GROUP BY address_state
)

SELECT *
FROM state_analysis
WHERE interest_income >
(
    SELECT AVG(interest_income)
    FROM state_analysis
)
AND default_rate >
(
    SELECT AVG(default_rate)
    FROM state_analysis
)
ORDER BY interest_income DESC;


/*
====================================================
Business Problem 42
====================================================

Business Problem:
Which grades deliver the best risk-adjusted return?

Business Value:
Evaluates profitability after accounting for default
risk, helping identify the most efficient credit grades
for long-term portfolio performance.

Dataset:
Financial Loan Dataset

Table:
- finance_loan

SQL Concepts Used:
- CTEs
- CASE WHEN
- Aggregations
- Derived KPIs
- Risk Adjusted Return Analysis
*/

WITH grade_analysis AS (
    SELECT
        grade,
        ROUND(
            SUM(total_payment - loan_amount),
            2
        ) AS interest_income,

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
    GROUP BY grade
)

SELECT
    grade,
    interest_income,
    default_rate,

    ROUND(
        interest_income /
        NULLIF(default_rate, 0),
        2
    ) AS risk_adjusted_return

FROM grade_analysis
ORDER BY risk_adjusted_return DESC;
    

