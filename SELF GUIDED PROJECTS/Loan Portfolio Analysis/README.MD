# SQL Portfolio: Loan Risk & Credit Analysis  

This project is part of my **SQL portfolio**, where I analyze a loan dataset to uncover risk and portfolio insights.  
I created derived features (DTI ratio, income brackets, credit tiers) and used SQL to answer key business questions about credit risk, loan performance, and policy consistency.  

---

## 🔎 Key Questions Answered  
- How does **DTI** vary across income brackets?  
- How is the loan portfolio distributed across **income brackets**?  
- What is the **average credit tier** within each income bracket?  
- What is the **approval rate** per income bracket and DTI tier combination?  
- How do **default rates** differ across income brackets and credit tiers?  
- Which income brackets are overrepresented in the **High-Risk DTI tier (>50%)**?  
- Are minimum loan amount policies applied consistently?  
- Are there **outliers** (e.g., low-income clients with high loan amounts or DTI)?  

---

## 🛠️ SQL Concepts Used  
- `CASE WHEN` for derived columns (income brackets, credit tiers, risk flags)  
- `WITH` and **CTEs** for cleaner, modular queries  
- **Subqueries** for layered analysis  
- Aggregations (`AVG`, `MIN`, `MAX`, `COUNT`, `SUM`)  
- Grouping and ordering for insights by segment  

---

## 📊 Example Queries  

**1. Average DTI by Income Bracket**  
```sql
SELECT 
    income_brackets,
    ROUND(AVG(dti_ratio), 3) AS avg_dti,
    ROUND(MIN(dti_ratio), 3) AS min_dti,
    ROUND(MAX(dti_ratio), 3) AS max_dti
FROM loan_defaults
GROUP BY income_brackets
ORDER BY avg_dti DESC;

