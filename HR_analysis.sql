

--1) What is the overall employee attrition rate in the company?
SELECT 
    Attrition,
    COUNT(*) AS EmployeeCount,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(5,2)) AS Percentage
FROM [dbo].[HR Analytics Clean]
GROUP BY Attrition;
/*Insight: Out of 1,473 employees, 237 (16.09%) left the company, while 1,236 (83.91%) stayed. This means roughly 1 in every 6 employees leaves — 
a moderate attrition rate that establishes the baseline for deeper analysis into why employees are leaving in the following questions.*/


--2)Which departments have the highest attrition rate?
SELECT 
    Department,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Left_Company,
    CAST(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS AttritionRate
FROM [dbo].[HR Analytics Clean]
GROUP BY Department
ORDER BY AttritionRate DESC;
/*Insight: The Sales department has the highest attrition rate at 20.58% (92 out of 447 employees), 
followed by Human Resources at 19.05% (12 out of 63), while Research & Development has the lowest rate 
among the three at 13.81% (133 out of 963). Although R&D has the largest employee base, it retains staff better than Sales —
suggesting the attrition problem is concentrated in customer-facing/target-driven roles rather than being company-wide.*/



--3) Which job roles are most prone to attrition?
SELECT 
    JobRole,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Left_Company,
    CAST(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS AttritionRate
FROM [dbo].[HR Analytics Clean]
GROUP BY JobRole
ORDER BY AttritionRate DESC;

/*Insight: Sales Representative has the highest attrition rate among all job roles at 39.29% (33 out of 84),
followed by Laboratory Technician at 23.85% and Human Resources at 23.08%. In contrast,
senior roles like Research Director (2.50%) and Manager (4.90%) show very low attrition.
This reveals a clear pattern: attrition is strongly linked to job level,
with junior/entry-level roles being far more vulnerable to turnover than management positions.*/

--4) Do employees who work overtime leave the company more than those who don't?
SELECT 
    OverTime,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Left_Company,
    CAST(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS AttritionRate
FROM [dbo].[HR Analytics Clean]
GROUP BY OverTime
ORDER BY AttritionRate DESC;

/*Insight: Employees who work overtime have an attrition rate of 30.53% (127 out of 416), 
nearly 3x higher than those who don't work overtime at 10.41% (110 out of 1057). 
This makes overtime one of the strongest predictors of employee turnover identified so far, 
suggesting a direct link between work-life imbalance/burnout and the decision to leave the company.*/

--5) What is the effect of age group on attrition rate?
SELECT 
    AgeGroup,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Left_Company,
    CAST(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS AttritionRate
FROM [dbo].[HR Analytics Clean]
GROUP BY AgeGroup
ORDER BY AgeGroup;

/*Insight: Attrition rate decreases sharply as age increases, from 35.77% in the 18-25 
age group down to 9.15% in the 36-45 age group, then rises slightly again in the 46-55 
(11.50%) and 55+ (17.02%) groups. This shows that younger employees are by far the most 
likely to leave, while mid-career employees (36-45) are the most stable.*/

--6) Does low job satisfaction increase the likelihood of attrition?
SELECT 
    Attrition,
    AVG(CAST(JobSatisfaction AS FLOAT)) AS AvgJobSatisfaction,
    AVG(CAST(EnvironmentSatisfaction AS FLOAT)) AS AvgEnvSatisfaction,
    AVG(CAST(WorkLifeBalance AS FLOAT)) AS AvgWorkLifeBalance,
    AVG(CAST(RelationshipSatisfaction AS FLOAT)) AS AvgRelationshipSatisfaction
FROM [dbo].[HR Analytics Clean]
GROUP BY Attrition;

/*Insight: Employees who left the company (Attrition = Yes) have consistently lower average 
satisfaction scores across all four dimensions compared to those who stayed: Job Satisfaction 
(2.47 vs 2.78), Environment Satisfaction (2.46 vs 2.77), Work-Life Balance (2.66 vs 2.78), and 
Relationship Satisfaction (2.60 vs 2.73). While the gaps are modest on a 1-4 scale, the pattern 
is consistent across every satisfaction metric, confirming that lower satisfaction is associated 
with a higher likelihood of leaving.*/

--7) What is the relationship between years at company and attrition rate?
SELECT 
    CASE 
        WHEN YearsAtCompany < 2 THEN '0-2'
        WHEN YearsAtCompany BETWEEN 2 AND 5 THEN '2-5'
        WHEN YearsAtCompany BETWEEN 6 AND 10 THEN '6-10'
        ELSE '10+'
    END AS TenureGroup,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Left_Company,
    CAST(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS AttritionRate
FROM [dbo].[HR Analytics Clean]
GROUP BY 
    CASE 
        WHEN YearsAtCompany < 2 THEN '0-2'
        WHEN YearsAtCompany BETWEEN 2 AND 5 THEN '2-5'
        WHEN YearsAtCompany BETWEEN 6 AND 10 THEN '6-10'
        ELSE '10+'
    END
ORDER BY TenureGroup;

/*Insight: Attrition rate is highest among employees in their first 2 years at the company 
(34.88%, 75 out of 215), then drops sharply to 15.45% for 2-5 years and 12.25% for 6-10 years, 
reaching its lowest point at 8.13% for employees with 10+ years of tenure (20 out of 246). 
This shows a clear pattern: the risk of leaving decreases steadily as tenure increases, with 
new employees being by far the most vulnerable group.*/

--8) Does distance from home affect the likelihood of attrition?
SELECT 
    CASE 
        WHEN DistanceFromHome <= 5 THEN 'Near (0-5)'
        WHEN DistanceFromHome BETWEEN 6 AND 15 THEN 'Medium (6-15)'
        ELSE 'Far (16+)'
    END AS DistanceGroup,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Left_Company,
    CAST(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS AttritionRate
FROM [dbo].[HR Analytics Clean]
GROUP BY 
    CASE 
        WHEN DistanceFromHome <= 5 THEN 'Near (0-5)'
        WHEN DistanceFromHome BETWEEN 6 AND 15 THEN 'Medium (6-15)'
        ELSE 'Far (16+)'
    END
ORDER BY DistanceGroup;

/*Insight: Attrition rate increases with distance from home, from 13.74% for employees living 
nearby (0-5 miles, 87 out of 633) to 16.08% for medium distance (6-15 miles, 82 out of 510), 
reaching its highest point at 20.61% for employees living far away (16+ miles, 68 out of 330). 
This shows a moderate but noticeable trend: the farther an employee lives from work, the more 
likely they are to leave the company, likely due to longer, more tiring commutes.*/


--9) What is the average monthly income by department and job level?
SELECT 
    Department,
    JobLevel,
    COUNT(*) AS EmployeeCount,
    AVG(MonthlyIncome) AS AvgMonthlyIncome,
    MIN(MonthlyIncome) AS MinIncome,
    MAX(MonthlyIncome) AS MaxIncome
FROM [dbo].[HR Analytics Clean]
GROUP BY Department, JobLevel
ORDER BY Department, JobLevel;

/*Insight: Monthly income scales consistently with job level across all three departments, 
rising from roughly $2,500-2,800 at Level 1 to $19,000-19,200 at Level 5 — nearly an 8x 
increase. The pay structure is fairly consistent across departments at each level (e.g., 
Level 3 ranges $9,200-10,200 across all departments), indicating that job level, not 
department, is the primary driver of salary differences within the company.*/



--10) Who are the top 5 highest-paid employees in each department?
SELECT *
FROM (
    SELECT 
        EmpID, Department, JobRole, MonthlyIncome,
        RANK() OVER (PARTITION BY Department ORDER BY MonthlyIncome DESC) AS SalaryRank
    FROM [dbo].[HR Analytics Clean]
) t
WHERE SalaryRank <= 5
ORDER BY Department, SalaryRank;


/*Insight: Using a RANK() window function, the top 5 highest-paid employees in each department 
are almost entirely Managers, with monthly incomes ranging from ~$19,100 to ~$19,999 across 
Human Resources, Research & Development, and Sales. The only exception is a "Research Director" 
appearing in R&D's top earner spot ($19,999), suggesting managerial and director-level roles 
represent the peak earning positions in every department.*/

--11) Is there a relationship between the number of companies an employee has previously worked at and their likelihood of leaving?
SELECT 
    CASE 
        WHEN NumCompaniesWorked = 0 THEN '0'
        WHEN NumCompaniesWorked BETWEEN 1 AND 2 THEN '1-2'
        WHEN NumCompaniesWorked BETWEEN 3 AND 5 THEN '3-5'
        ELSE '6+'
    END AS CompaniesGroup,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Left_Company,
    CAST(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS AttritionRate
FROM [dbo].[HR Analytics Clean]
GROUP BY 
    CASE 
        WHEN NumCompaniesWorked = 0 THEN '0'
        WHEN NumCompaniesWorked BETWEEN 1 AND 2 THEN '1-2'
        WHEN NumCompaniesWorked BETWEEN 3 AND 5 THEN '3-5'
        ELSE '6+'
    END
ORDER BY CompaniesGroup;

/*Insight: Employees with 6+ previous companies have the highest attrition rate at 20.82% 
(51 out of 245), followed by those with 1-2 previous companies at 17.09% (114 out of 667). 
Interestingly, employees with 0 prior companies (their first job) show the lowest attrition 
at 11.62%, while the 3-5 group sits in between at 13.50%. This suggests that employees with 
a history of frequent job-hopping are more likely to leave again, while first-time employees 
tend to be more stable/loyal.*/

--12) Is there a difference in attrition rate between married and single employees, and does it vary by gender?
SELECT 
    MaritalStatus,
    Gender,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Left_Company,
    CAST(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS AttritionRate
FROM [dbo].[HR Analytics Clean]
GROUP BY MaritalStatus, Gender
ORDER BY MaritalStatus, Gender;

/*Insight: Marital status has a strong effect on attrition, with Single employees showing 
the highest rates (Male: 26.94%, Female: 23.50%), followed by Married (Male: 13.15%, 
Female: 11.40%), and Divorced employees showing the lowest attrition (Male: 11.43%, 
Female: 7.69%). Gender differences within each marital status are relatively small, 
suggesting that marital/life stability -- not gender -- is the stronger predictor of 
whether an employee stays or leaves.*/











