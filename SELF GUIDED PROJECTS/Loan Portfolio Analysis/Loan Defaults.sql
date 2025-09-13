-- Questions to answer Part 1
-- How is our loan portfolio distributed across different income brackets?
-- What is the average loan size per income bracket?
-- How does DTI vary across income brackets?
-- Can you provide a 3-way breakdown of loan count by: Income Bracket × DTI Tier × Credit Tier?
-- Which income brackets are overrepresented in the "high-risk" DTI tier (>50%)?
-- How do delinquency or default rates vary across income brackets?
-- Are we applying minimum income thresholds consistently across different loan types?
-- Are there outliers—clients in low-income brackets approved for large loans or high DTIs?

-- Feature Engineering
SET SQL_SAFE_UPDATES = 0;

ALTER TABLE loan_defaults
ADD COLUMN income_brackets VARCHAR (20),
ADD COLUMN credit_tiers VARCHAR (20),
ADD COLUMN dti_tiers VARCHAR (20);

-- Income brackets (Used Kenya's official income brackets)
UPDATE loan_defaults
SET income_brackets = CASE
		WHEN income < 20000 THEN 'Low Income'
        WHEN income BETWEEN 20000 AND 49999 THEN 'Lower Middle'
        WHEN income BETWEEN 50000 AND 99999 THEN 'Middle Income'
        WHEN income BETWEEN 100000 AND 199999 THEN 'Upper Middle'
	ELSE 'High Income'
END,

-- Credit Tiers (Used approved FICO credit ranges)
credit_tiers = CASE 
		WHEN credit_score < 580 THEN 'Poor' -- Very Risky borrower
        WHEN credit_score BETWEEN 580 AND 669 THEN 'Fair' -- Risky borrower
        WHEN credit_score BETWEEN 670 AND 739 THEN 'Good' -- Average borrower
        WHEN credit_score BETWEEN 740 AND 799 THEN 'Very Good' -- Low Risk borrower
	ELSE 'Exceptional' -- Very Low Risk borrower
END,

-- DTI Tiers (Used finance industry acceptable ranges)
dti_tiers =	CASE 
		WHEN dti_ratio < 0.360 THEN 'Excellent'
        WHEN dti_ratio BETWEEN 0.360 AND 0.430 THEN 'Acceptable'
        WHEN dti_ratio BETWEEN 0.440 AND 0.500 THEN 'Risky'
	ELSE 'High Risk'
END;

SET SQL_SAFE_UPDATES = 1;

-- Questions
-- How is our loan portfolio distributed across different income brackets?
SELECT income_brackets AS IB,
COUNT(*) AS total_loans_per_IB, 
sum(loan_amount) AS loan_amounts_per_IB
FROM loan_defaults
GROUP BY income_brackets
ORDER BY total_loans_per_IB desc;

-- What is the average loan size within each income bracket?
SELECT income_brackets,
	ROUND(avg(loan_amount),3) AS avg_loan,
    ROUND(MIN(loan_amount),3) AS min_loan,
    ROUND(MAX(loan_amount),3) AS max_loan
FROM loan_defaults
GROUP BY income_brackets
ORDER BY avg_loan DESC;

-- How does DTI vary across income brackets?
SELECT 
    income_brackets,
    ROUND(AVG(dti_ratio),3) AS avg_dti,
    ROUND(MIN(dti_ratio),3) AS min_dti,
    ROUND(MAX(dti_ratio),3) AS max_dti
FROM loan_defaults
GROUP BY income_brackets
ORDER BY avg_dti DESC;

-- What is the average loan term across income brackets and credit tiers?
SELECT income_brackets, credit_tiers, 
    ROUND(AVG(loan_term),2) AS avg_loan_term,
	MIN(loan_term) AS min_loan_term,
	MAX(loan_term) AS max_loan_term
FROM loan_defaults
GROUP BY income_brackets, credit_tiers
ORDER BY income_brackets, credit_tiers;

-- What types of loans are being taken by each income bracket?
SELECT income_brackets, 
       loan_purpose, 
       COUNT(*) AS total_loans, 
       ROUND(COUNT(*) *100 / SUM(COUNT(*)) OVER (PARTITION BY income_brackets), 2) AS pct_within_bracket
FROM loan_defaults
GROUP BY income_brackets, loan_purpose
ORDER BY income_brackets, total_loans DESC;

-- What is the default rate within each credit tier?
SELECT credit_tiers,
    ROUND((SUM(CASE WHEN defaulted = 1 THEN 1 ELSE 0 END) * 100) / COUNT(*), 2) AS default_rate
FROM loan_defaults
GROUP BY credit_tiers
ORDER BY default_rate DESC;

-- What percentage of loans in each credit tier fall into the High-Risk DTI category (>50%)?
SELECT credit_tiers,
    ROUND(SUM(CASE WHEN dti_ratio > 0.50 THEN 1 ELSE 0 END) * 100 / COUNT(*), 2) AS high_risk_dti_pct
FROM loan_defaults
GROUP BY credit_tiers
ORDER BY high_risk_dti_pct DESC;

-- Which loan categories contribute most to the high-risk segment?
SELECT 
    loan_purpose,
    ROUND(COUNT(*) * 100 / (SELECT COUNT(*) FROM loan_defaults WHERE dti_ratio > 0.50), 2) AS high_risk_pct
FROM loan_defaults
WHERE dti_ratio > 0.50
GROUP BY loan_purpose
ORDER BY high_risk_pct DESC;

-- Is the minimum loan amount offered consistent across income brackets and credit tiers?
WITH min_values AS (
    SELECT 
        income_brackets,
        credit_tiers,
        MIN(loan_amount) AS min_loan_amount
    FROM loan_defaults
    GROUP BY income_brackets, credit_tiers
)
SELECT 
    income_brackets,
    credit_tiers,
    min_loan_amount,
    CASE 
        WHEN min_loan_amount < 5100
        THEN 'Consistent'
        ELSE 'Inconsistent'
    END AS policy_check
FROM min_values
ORDER BY min_loan_amount DESC;