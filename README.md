# HR Employee Attrition Analysis

Why do employees leave this company, and who's most likely to go next? I used SQL to clean and analyze data on 1,473 employees, then built a Power BI dashboard to explore the results by department.

**Dataset:** IBM HR Analytics Attrition Dataset (Kaggle)
**Tools:** SQL Server, Power BI

!\[Overview](./Dashboard%20Screenshot/overview.png)

## 🧹 Cleaning the data

Before analyzing anything, I checked the data for problems — duplicate employee IDs, typos in category fields, and columns that didn't match their expected type. I found 16 numeric columns (like job satisfaction and years at company) stored as text instead of numbers, and 57 missing values in `YearsWithCurrManager`, both of which I fixed.

📄 `data\_cleaning.sql`

## 📊 Analyzing the data

I wrote 12 SQL queries to answer specific questions about attrition — by department, job role, overtime, age, tenure, and more — including a window function to rank top earners in each department.

📄 `HR\_analysis.sql`

## 📈 The dashboard

Built in Power BI, connected directly to the cleaned data, and filterable by department:

||Employees|Attrition|Rate|Avg. Salary|
|-|-|-|-|-|
|Overview|1,473|237|16.1%|6.50K|
|Human Resources|63|12|19.0%|6.65K|
|Research \& Development|963|133|13.8%|6.28K|
|Sales|447|92|20.6%|6.95K|

!\[Human Resources](./Dashboard%20Screenshot/human-resources.png)
*Human Resources — 63 employees, 19.0% attrition rate*

!\[Research \& Development](./Dashboard%20Screenshot/rd.png)
*Research \& Development — 963 employees, 13.8% attrition rate*

!\[Sales](./Dashboard%20Screenshot/sales.png)
*Sales — 447 employees, 20.6% attrition rate*

## 💡 What stood out

* **Sales has the highest attrition rate (20.6%)** — driven mostly by junior sales roles
* **Overtime employees leave \~3x more often** than those who don't work overtime
* **The first two years are the riskiest period** — attrition drops sharply after that, and is highest among employees under 25
* **Single employees leave more often** than married or divorced employees
* **R\&D has the lowest attrition (13.8%)** despite being the largest department

## ✅ What I'd suggest

* Strengthen onboarding and support for employees in their first two years
* Review workload and overtime policy, especially in Sales
* Consider flexible/hybrid work for employees with long commutes

## 📁 Files

* `data\_cleaning.sql` — cleaning and quality checks
* `HR\_analysis.sql` — 12 SQL queries with findings
* `Power Bi.pbix` — the full dashboard
* `HR Analytics.csv` — raw data
* `Dashboard Screenshot/` — dashboard images



