CREATE TABLE EmployeeDemographics
(
EmployeeID INT PRIMARY KEY,
FirstName NVARCHAR (10),
LastName NVARCHAR (10),
Age INT,
Gender NVARCHAR (7)
);


INSERT INTO EmployeeDemographics VALUES 
(1001, 'Jim', 'Halpert', 30, 'Male'),
(1002, 'Pam', 'Bealsey', 30, 'Female'),
(1003, 'Dwight', 'Schrute', 29, 'Male'),
(1004, 'Angela', 'Martin', 31, 'Female'),
(1005, 'Toby', 'Flenderson', 32, 'Male'),
(1006, 'Michael', 'Palmer', 32, 'Female'),
(1007, 'Meredith', 'Scott', 35, 'Female'),
(1008, 'Stanley', 'Hudson', 38, 'Male'),
(1009, 'Kevin', 'Malone', 31, 'Male')

CREATE TABLE EmployeeSalary 
(
EmployeeID INT PRIMARY KEY,
JobTitle NVARCHAR (30),
Salary INt
);

INSERT INTO EmployeeSalary VALUES 
(1001, 'Salesman', 45000),
(1002, 'Receptionist', 36000),
(1003, 'Salesman', 63000),
(1004, 'Accountant', 47000),
(1005, 'HR', 50000),
(1006, 'Regional Manager', 65000),
(1007, 'Supplier Relation', 41000),
(1008, 'Salesman', 48000),
(1009, 'Accountant', 42000)


Select JobTitle, AVG (Salary)
FROM EmployeeDemographics
INNER JOIN EmployeeSalary
	ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID
WHERE JobTitle = 'Salesman'
GROUP BY JobTitle

SELECT Gender, COUNT (Gender)
From EmployeeDemographics
GROUP BY Gender


SELECT EmployeeID, FirstName, Age
FROM EmployeeDemographics
UNION
SELECT EmployeeID, JobTitle, Salary
FROM EmployeeSalary
ORDER BY EmployeeID

SELECT FirstName, LastName, JobTitle, Salary,
CASE
	WHEN JobTitle = 'Salesman' THEN Salary + (Salary * .10)
	WHEN JobTitle = 'Accountant' THEN Salary + (Salary * .07)
	ELSE Salary + (Salary * 0.04)
END AS SalaryAfterRaise
FROM EmployeeDemographics
JOIN EmployeeSalary
ON EmployeeDemographics. EmployeeID = EmployeeSalary. EmployeeID

SELECT JobTitle, COUNT (JobTitle) AS num
FROM EmployeeSalary
GROUP BY JobTitle
HAVING COUNT(JobTitle) > 1
ORDER BY COUNT(JobTitle) DESC

SELECT JobTitle, AVG(Salary) AS AvrageSalary
FROM EmployeeSalary
GROUP BY JobTitle
HAVING AVG(Salary) > 45000
ORDER BY AVG(Salary)

SELECT * 
FROM EmployeeDemographics

UPDATE EmployeeDemographics
SET EmployeeID = 1002
WHERE FirstName = 'Pam'

DELETE FROM EmployeeDemographics
WHERE EmployeeID = 1001
SELECT * 
FROM EmployeeDemographics

INSERT INTO EmployeeDemographics 
VALUES(1001, 'Jim', 'Halpert', 30, 'Male')

SELECT FirstName + ' ' + LastName FullName
FROM EmployeeDemographics

SELECT FirstName, LastName, Gender, Salary
, COUNT (Gender) OVER (PARTITION BY Gender) AS TotalGender
FROM EmployeeDemographics DEMO
JOIN EmployeeSalary SAL
	ON DEMO.EmployeeID = SAL.EmployeeID

SELECT FirstName, LastName, Gender, Salary
, COUNT (Gender) AS Total
FROM EmployeeDemographics DEMO
JOIN EmployeeSalary SAL
	ON DEMO.EmployeeID = SAL.EmployeeID
GROUP BY FirstName, LastName, Gender, Salary

CREATE TABLE #temp_Employee
(
EmployyID INT,
JobTitle NVARCHAR(20),
Salary NVARCHAR (20)
);

INSERT INTO #temp_Employee 
SELECT *
FROM EmployeeSalary

DROP TABLE IF EXISTS #temp_Employee2
CREATE TABLE #temp_Employee2 
(
JobTitle NVARCHAR(50),
EmployeesPerJob INT,
AvgAge INT,
AvgSalary INT
);

INSERT INTO #temp_Employee2 
SELECT JobTitle, COUNT(JobTitle), AVG(Age), AVG(Salary)
FROM EmployeeDemographics demo
JOIN EmployeeSalary sal
	ON demo.EmployeeID = sal.EmployeeID
GROUP BY JobTitle

SELECT *
FROM #temp_Employee2 

DROP TABLE IF EXISTS EmployeeErrors
CREATE TABLE EmployeeErrors (
EmployeeID VARCHAR (50),
FirstName VARCHAR (50),
LastName VARCHAR (50)
);
INSERT INTO EmployeeErrors VALUES 
('1001	', 'Jimbo', 'Halbert') ,
('   1002', 'Pamela', 'Beasely') ,
('1005', 'TOby', 'Flenderson - Fried') 

SELECT *
FROM EmployeeErrors

--TIRM
SELECT EmployeeID, TRIM(EmployeeID) AS IDTRIM
FROM EmployeeErrors

SELECT EmployeeID, LTRIM(EmployeeID) AS IDTRIM
FROM EmployeeErrors

SELECT EmployeeID, RTRIM(EmployeeID) AS IDTRIM
FROM EmployeeErrors


--REPLACE
SELECT LastName, REPLACE(LastName, '- Fried','') AS LastNameFixed
FROM EmployeeErrors

--USING SUBSTRING
SELECT SUBSTRING(ERR.FirstName, 1, 3) , SUBSTRING(DEM.FirstName, 1, 3)
FROM EmployeeErrors ERR
JOIN EmployeeDemographics DEM
	ON SUBSTRING(ERR.FirstName, 1, 3) = SUBSTRING(DEM.FirstName, 1, 3)


SELECT SUBSTRING (FirstName, 3, 3)
FROM EmployeeErrors

--UPPER AND LOWER
SELECT FirstName, LOWER(FirstName) AS LowerName
FROM EmployeeErrors

SELECT FirstName, UPPER(FirstName) AS UpperName
FROM EmployeeErrors

--PROCEDURE TESTS
CREATE PROCEDURE TEST
AS
SELECT *
FROM EmployeeDemographics

EXEC TEST


CREATE PROCEDURE Temp_Employee
AS
CREATE TABLE #temp_Employee 
(
JobTitle VARCHAR(50),
EmployeesPerJob INT,
AvgAge INT,
AvgSalary INT
)

INSERT INTO #temp_Employee 
SELECT JobTitle, COUNT(JobTitle), AVG(Age), AVG(Salary)
FROM EmployeeDemographics demo
JOIN EmployeeSalary sal
	ON demo.EmployeeID = sal.EmployeeID
GROUP BY JobTitle
SELECT *
FROM #temp_Employee 

EXEC Temp_Employee @JobTitle = 'Salesman'

--SUBQUERY IN SELECT
SELECT EmployeeID, Salary, (SELECT AVG(Salary) FROM EmployeeSalary) AS AllAvg
FROM EmployeeSalary

--IN PARTITION BY
SELECT EmployeeID, Salary, AVG(Salary) OVER() AS AllAvg
FROM EmployeeSalary

--SUBQUERY IN FROM
SELECT A.EmployeeID, AllAvg
FROM (SELECT EmployeeID, Salary, (SELECT AVG(Salary) FROM EmployeeSalary) AS AllAvg
	FROM EmployeeSalary) A

--SUBQUERY IN FROM
SELECT EmployeeID, JobTitle, Salary
FROM EmployeeSalary
WHERE EmployeeID IN (
	SELECT EmployeeID
	FROM EmployeeDemographics 
	WHERE Age > 30)


