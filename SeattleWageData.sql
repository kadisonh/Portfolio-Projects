-- Quick look at table

SELECT *
FROM PortfolioProject..City_of_Seattle_Wage_Data$

-- Who makes the most

SELECT *
FROM PortfolioProject..City_of_Seattle_Wage_Data$
ORDER BY [Hourly Rate] DESC

-- Which department makes the most

Select Department, SUM([Hourly Rate]) as DepartmentHourlyRate
FROM PortfolioProject..City_of_Seattle_Wage_Data$
GROUP BY Department
ORDER BY DepartmentHourlyRate DESC

-- Which department has the most workers

Select Department, COUNT(Department) as NumWorkers
FROM PortfolioProject..City_of_Seattle_Wage_Data$
GROUP BY Department
ORDER BY NumWorkers DESC

-- Just look at average salary for each department

SELECT Department, AVG([Hourly Rate]) as DepartmentAVGHourlyRate
FROM PortfolioProject..City_of_Seattle_Wage_Data$
GROUP BY Department
ORDER BY DepartmentAVGHourlyRate DESC

-- Look at all side by side

SELECT Department, ROUND(SUM([Hourly Rate]), 2)as DepartmentHourlyRate,  ROUND(AVG([Hourly Rate]), 2) as DepartmentAVGHourlyRate, COUNT(Department) as NumWorkers
FROM PortfolioProject..City_of_Seattle_Wage_Data$
GROUP BY Department
ORDER BY DepartmentHourlyRate DESC, DepartmentAVGHourlyRate DESC, NumWorkers DESC

-- Okay how about looking at a percentage to put stuff into better persepctive (using CTE)

WITH Totals (TotalHourlyRate, TotalWorkers)
as
(
SELECT SUM([Hourly Rate]) as TotalHourlyRate, COUNT(*) as TotalWorkers
FROM PortfolioProject..City_of_Seattle_Wage_Data$
)
SELECT Department, ROUND(SUM([Hourly Rate])/MAX(TotalHourlyRate)*100, 2) as PercentageHourlyRate, ROUND(CAST(COUNT(Department) as float)/MAX(TotalWorkers) * 100, 2) as PercentageWorkers
FROM PortfolioProject..City_of_Seattle_Wage_Data$, Totals
GROUP BY Department
ORDER BY PercentageHourlyRate DESC

-- Using temp table instead

Drop Table if exists #TotalsTemp
Create Table #TotalsTemp
(
TotalHourlyRate numeric,
TotalWorkers numeric
)

Insert into #TotalsTemp
SELECT SUM([Hourly Rate]) as TotalHourlyRate, COUNT(*) as TotalWorkers
FROM PortfolioProject..City_of_Seattle_Wage_Data$

SELECT Department, ROUND(SUM([Hourly Rate])/MAX(TotalHourlyRate)*100, 2) as PercentageHourlyRate, ROUND(CAST(COUNT(Department) as float)/MAX(TotalWorkers) * 100, 2) as PercentageWorkers
FROM PortfolioProject..City_of_Seattle_Wage_Data$, #TotalsTemp
GROUP BY Department
ORDER BY PercentageHourlyRate DESC

-- For fun lets see what first names make the most
-- First lets even see if there are many overlapping names
SELECT COUNT(DISTINCT [First Name]) as [Unique First Names], COUNT(*) as [Total Rows]
FROM PortfolioProject..City_of_Seattle_Wage_Data$

-- There are so now we can group by first names
-- Filtered so only those with 50 or names are shown, can refine search more but this will do
SELECT [First Name], AVG([Hourly Rate]) as NameAVGHourlyRate, COUNT([First Name]) as TotalWorkersWithFirstName
FROM PortfolioProject..City_of_Seattle_Wage_Data$
GROUP BY [First Name]
HAVING COUNT([First Name]) > 50
ORDER BY NameAVGHourlyRate DESC