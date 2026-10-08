-- Risk Score للموظفين
-- الفكرة: ندي درجة خطر لكل موظف بناءً على الحاجات اللي طلعَت مؤثرة في التحليل

-- 1) تفاصيل الـ Risk Score لكل موظف
SELECT 
    EmpID,
    Department,
    JobRole,
    Age,
    YearsAtCompany,
    OverTime,
    MaritalStatus,
    DistanceFromHome,
    JobSatisfaction,
    Attrition,

    (CASE WHEN OverTime = 'Yes' THEN 3 ELSE 0 END) +
    (CASE WHEN YearsAtCompany < 2 THEN 3 ELSE 0 END) +
    (CASE WHEN Age < 26 THEN 2 ELSE 0 END) +
    (CASE WHEN MaritalStatus = 'Single' THEN 2 ELSE 0 END) +
    (CASE WHEN DistanceFromHome >= 16 THEN 1 ELSE 0 END) +
    (CASE WHEN JobRole = 'Sales Representative' THEN 2 ELSE 0 END) +
    (CASE WHEN JobSatisfaction IN (1,2) THEN 1 ELSE 0 END) AS RiskScore,

    CASE 
        WHEN (
            (CASE WHEN OverTime = 'Yes' THEN 3 ELSE 0 END) +
            (CASE WHEN YearsAtCompany < 2 THEN 3 ELSE 0 END) +
            (CASE WHEN Age < 26 THEN 2 ELSE 0 END) +
            (CASE WHEN MaritalStatus = 'Single' THEN 2 ELSE 0 END) +
            (CASE WHEN DistanceFromHome >= 16 THEN 1 ELSE 0 END) +
            (CASE WHEN JobRole = 'Sales Representative' THEN 2 ELSE 0 END) +
            (CASE WHEN JobSatisfaction IN (1,2) THEN 1 ELSE 0 END)
        ) >= 7 THEN 'High Risk'
        WHEN (
            (CASE WHEN OverTime = 'Yes' THEN 3 ELSE 0 END) +
            (CASE WHEN YearsAtCompany < 2 THEN 3 ELSE 0 END) +
            (CASE WHEN Age < 26 THEN 2 ELSE 0 END) +
            (CASE WHEN MaritalStatus = 'Single' THEN 2 ELSE 0 END) +
            (CASE WHEN DistanceFromHome >= 16 THEN 1 ELSE 0 END) +
            (CASE WHEN JobRole = 'Sales Representative' THEN 2 ELSE 0 END) +
            (CASE WHEN JobSatisfaction IN (1,2) THEN 1 ELSE 0 END)
        ) BETWEEN 4 AND 6 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS RiskCategory

FROM [dbo].[HR Analytics Clean];


-- 2) ملخص توزيع درجة الخطر
SELECT 
    RiskCategory,
    COUNT(*) AS EmployeeCount,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS LeftCompany,
    CAST(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS AttritionRate
FROM (
    SELECT 
        Attrition,
        CASE 
            WHEN (
                (CASE WHEN OverTime = 'Yes' THEN 3 ELSE 0 END) +
                (CASE WHEN YearsAtCompany < 2 THEN 3 ELSE 0 END) +
                (CASE WHEN Age < 26 THEN 2 ELSE 0 END) +
                (CASE WHEN MaritalStatus = 'Single' THEN 2 ELSE 0 END) +
                (CASE WHEN DistanceFromHome >= 16 THEN 1 ELSE 0 END) +
                (CASE WHEN JobRole = 'Sales Representative' THEN 2 ELSE 0 END) +
                (CASE WHEN JobSatisfaction IN (1,2) THEN 1 ELSE 0 END)
            ) >= 7 THEN 'High Risk'
            WHEN (
                (CASE WHEN OverTime = 'Yes' THEN 3 ELSE 0 END) +
                (CASE WHEN YearsAtCompany < 2 THEN 3 ELSE 0 END) +
                (CASE WHEN Age < 26 THEN 2 ELSE 0 END) +
                (CASE WHEN MaritalStatus = 'Single' THEN 2 ELSE 0 END) +
                (CASE WHEN DistanceFromHome >= 16 THEN 1 ELSE 0 END) +
                (CASE WHEN JobRole = 'Sales Representative' THEN 2 ELSE 0 END) +
                (CASE WHEN JobSatisfaction IN (1,2) THEN 1 ELSE 0 END)
            ) BETWEEN 4 AND 6 THEN 'Medium Risk'
            ELSE 'Low Risk'
        END AS RiskCategory
    FROM [dbo].[HR Analytics Clean]
) t
GROUP BY RiskCategory
ORDER BY 
    CASE RiskCategory 
        WHEN 'High Risk' THEN 1 
        WHEN 'Medium Risk' THEN 2 
        ELSE 3 
    END;



 /*
نتائج الـ Risk Score:
- High Risk  : 113 موظف  → نسبة الترك 55.75%
- Medium Risk: 370 موظف  → نسبة الترك 27.30%
- Low Risk   : 990 موظف  → نسبة الترك 7.37%

الـ Score شغال كويس، لأن الفرق واضح بين الفئات.
*/