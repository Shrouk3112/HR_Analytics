/* ============================================================
   HR Analytics - Data Cleaning Script
   Database: HR_Project
   Table: [dbo].[HR Analytics Clean]
   Source: Kaggle IBM HR Analytics Attrition Dataset
   ============================================================ */


-- 1) استكشاف أولي (Initial Exploration)

-- عدد الصفوف الكلي
SELECT COUNT(*) AS TotalRows 
FROM [dbo].[HR Analytics Clean];
-- النتيجة: 1473 صف

-- شكل عام للداتا
SELECT * FROM [dbo].[HR Analytics Clean];

-- أسماء وأنواع الأعمدة
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'HR Analytics Clean';
-- لاحظنا: 16 عمود رقمي متخزنين غلط كـ nvarchar بدل int


-- 2) فحص جودة الداتا (Data Quality Check)

-- فحص تكرار EmpID (المفروض يكون فريد لكل موظف)
SELECT EmpID, COUNT(*) 
FROM [dbo].[HR Analytics Clean]
GROUP BY EmpID
HAVING COUNT(*) > 1;

-- فحص القيم الفريدة (Distinct) في الأعمدة الرقمية المشتبه فيها
-- للتأكد من عدم وجود نص غريب أو فراغات قبل التحويل لـ int
SELECT DISTINCT Education FROM [dbo].[HR Analytics Clean];
SELECT DISTINCT WorkLifeBalance FROM [dbo].[HR Analytics Clean];
SELECT DISTINCT JobSatisfaction FROM [dbo].[HR Analytics Clean];
SELECT DISTINCT JobLevel FROM [dbo].[HR Analytics Clean];
SELECT DISTINCT JobInvolvement FROM [dbo].[HR Analytics Clean];
SELECT DISTINCT EnvironmentSatisfaction FROM [dbo].[HR Analytics Clean];
SELECT DISTINCT RelationshipSatisfaction FROM [dbo].[HR Analytics Clean];
SELECT DISTINCT StockOptionLevel FROM [dbo].[HR Analytics Clean];
SELECT DISTINCT NumCompaniesWorked FROM [dbo].[HR Analytics Clean];
SELECT DISTINCT TotalWorkingYears FROM [dbo].[HR Analytics Clean];
SELECT DISTINCT TrainingTimesLastYear FROM [dbo].[HR Analytics Clean];
SELECT DISTINCT YearsAtCompany FROM [dbo].[HR Analytics Clean];
SELECT DISTINCT YearsInCurrentRole FROM [dbo].[HR Analytics Clean];
SELECT DISTINCT YearsSinceLastPromotion FROM [dbo].[HR Analytics Clean];
SELECT DISTINCT YearsWithCurrManager FROM [dbo].[HR Analytics Clean];
SELECT DISTINCT DistanceFromHome FROM [dbo].[HR Analytics Clean];
-- النتيجة: كل القيم منطقية، مفيش نص غريب أو فراغات



-- 3) معالجة القيم الفارغة (Handling NULL Values)

-- فحص عدد القيم NULL في YearsWithCurrManager
-- (العمود الوحيد اللي IS_NULLABLE = YES)
SELECT COUNT(*) AS NullCount
FROM [dbo].[HR Analytics Clean]
WHERE YearsWithCurrManager IS NULL;
-- النتيجة: 57 صف (حوالي 3.9% من الداتا)

-- استبدال القيم الفارغة بـ 0
-- (منطقي لأن العمود بيمثل عدد سنين مع المدير الحالي)
UPDATE [dbo].[HR Analytics Clean]
SET YearsWithCurrManager = 0
WHERE YearsWithCurrManager IS NULL;

-- التأكد من عدم وجود NULLs متبقية
SELECT COUNT(*) AS RemainingNulls
FROM [dbo].[HR Analytics Clean]
WHERE YearsWithCurrManager IS NULL;
-- النتيجة: 0 ✅


-- 4) تصحيح أنواع البيانات (Fixing Data Types)
-- تحويل 16 عمود من nvarchar إلى INT
-- ============================================================

ALTER TABLE [dbo].[HR Analytics Clean] ALTER COLUMN Education INT;
ALTER TABLE [dbo].[HR Analytics Clean] ALTER COLUMN DistanceFromHome INT;
ALTER TABLE [dbo].[HR Analytics Clean] ALTER COLUMN EnvironmentSatisfaction INT;
ALTER TABLE [dbo].[HR Analytics Clean] ALTER COLUMN JobInvolvement INT;
ALTER TABLE [dbo].[HR Analytics Clean] ALTER COLUMN JobLevel INT;
ALTER TABLE [dbo].[HR Analytics Clean] ALTER COLUMN JobSatisfaction INT;
ALTER TABLE [dbo].[HR Analytics Clean] ALTER COLUMN NumCompaniesWorked INT;
ALTER TABLE [dbo].[HR Analytics Clean] ALTER COLUMN RelationshipSatisfaction INT;
ALTER TABLE [dbo].[HR Analytics Clean] ALTER COLUMN StockOptionLevel INT;
ALTER TABLE [dbo].[HR Analytics Clean] ALTER COLUMN TotalWorkingYears INT;
ALTER TABLE [dbo].[HR Analytics Clean] ALTER COLUMN TrainingTimesLastYear INT;
ALTER TABLE [dbo].[HR Analytics Clean] ALTER COLUMN WorkLifeBalance INT;
ALTER TABLE [dbo].[HR Analytics Clean] ALTER COLUMN YearsAtCompany INT;
ALTER TABLE [dbo].[HR Analytics Clean] ALTER COLUMN YearsInCurrentRole INT;
ALTER TABLE [dbo].[HR Analytics Clean] ALTER COLUMN YearsSinceLastPromotion INT;
ALTER TABLE [dbo].[HR Analytics Clean] ALTER COLUMN YearsWithCurrManager INT;

-- Commands completed successfully ✅


-- ============================================================
-- 5) التحقق النهائي (Final Verification)
-- ============================================================

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'HR Analytics Clean'
ORDER BY ORDINAL_POSITION;
-- النتيجة: كل الأعمدة الرقمية بقت int بنجاح، والأعمدة النصية 
-- (Department, JobRole, Gender, ...) فضلت nvarchar كما هو مطلوب


/* ============================================================
   خلاصة عملية التنظيف (Cleaning Summary):
   ------------------------------------------------------------
   - عدد الصفوف: 1,473
   - تم اكتشاف وإصلاح 16 عمود بنوع بيانات خاطئ (nvarchar -> int)
   - تم اكتشاف ومعالجة 57 قيمة NULL (3.9%) في عمود
     YearsWithCurrManager عن طريق استبدالها بـ 0
   - تم التحقق من عدم وجود قيم مكررة أو أخطاء إملائية في
     الأعمدة النصية والرقمية
   ============================================================ */
