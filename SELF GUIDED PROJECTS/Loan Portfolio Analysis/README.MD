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

📑 Insights

High DTI ratios are concentrated in lower-income brackets and weaker credit tiers.

Default rates are higher in low-income groups and weak credit tiers.

Some loans issued below policy thresholds, revealing inconsistencies.

Loan purpose and size vary significantly by income level, influencing repayment behavior.

🚀 Next Steps

Expand analysis with visualizations (Power BI / Tableau).

Add Part 2 with advanced queries (joins, window functions, trend analysis).

Explore predictive modeling on top of the SQL outputs.

📂 Structure

queries/ → SQL scripts for each question

presentation/ → PPT slides with summarized insights

README.md → Project overview (this file)

✨ Author

Created by Paulette Kihuha – Aspiring Data Analyst with a focus on credit risk and financial data analysis.

