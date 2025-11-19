-- STRING FUCCTIONS--
-- CONCAT
--Concatanate first name and country into one column
/*
SELECT 
first_name,
country,
CONCAT(first_name,' ', country) AS name_country
FROM customers

--TRANSFORM customers first name to lower case
-- UPPER AND LOWER
SELECT 
first_name,
country,
CONCAT(first_name,' ', country) AS name_country,
LOWER(first_name) AS low_name
FROM customers

-- TRIM
SELECT 
first_name,
country,
CONCAT(first_name,' ', country) AS name_country,
LOWER(first_name) AS low_name,
TRIM(first_name) AS remove_emptySpaces
FROM customers
-- OR ( to check their are data with blind spaces )
SELECT
first_name,
LEN(first_name) AS len_name,
LEN(TRIM(first_name)) AS len_trim_value,
LEN(first_name) - LEN(TRIM(first_name)) flag
FROM customers
WHERE first_name != TRIM(first_name)

-- REPLACE
-- remove dashes (-) from phone number
SELECT 
'123-123-1233' AS phone,
REPLACE('123-123-1233', '-', '') AS clean_phone

-- LEN calculate how many characters
SELECT
first_name,
LEN(first_name) AS countOFcharacters
FROM customers

--ETRACT CHARACTERS
SELECT
first_name,
LEFT(TRIM(first_name),2) AS first_twoWORDS,
RIGHT(TRIM(first_name),2) AS last_twoWORDS
FROM customers

-- SUBSTRING
-- after the 2nd character extract 2 caracters
SELECT
first_name,
SUBSTRING(TRIM(first_name),3,2) AS middle_caracters
FROM customers

-- more advance to extract all character except first letter
SELECT
first_name,
SUBSTRING(TRIM(first_name),2,LEN(first_name)) AS middle_caracters
FROM customers



-- Number Fuctions--


--ROUND
SELECT
3.344324,
ROUND(3.344324,2)

--ABS(ABSOLUTE)
SELECT
-123.54,
ABS(-123.54)



-- DATE AND TIME FUCTION--


SELECT 
OrderID,
OrderDate,
ShipDate,
CreationTime,
'2025-08-34',-- hardcoaded
GETDATE() Today
FROM Sales.Orders

-- PART EXTRACTION
DAY()
MONTH()
YEAR()

SELECT 
OrderID,
CreationTime,
YEAR(CreationTime),
MONTH(CreationTime),
DAY(CreationTime)
FROM Sales.Orders

-- DATEPART
SELECT 
OrderID,
CreationTime,
DATEPART(month, CreationTime) AS MONTH_PART, -- YOU CAN ALSO WRITE MM
DATEPART(WEEK, CreationTime) AS week_part,
DATEPART(HOUR, CreationTime) AS HOUR_part,
DATEPART(QUARTER, CreationTime) AS QUARTER_part
FROM Sales.Orders

 -- DATENME
SELECT 
OrderID,
CreationTime,
DATENAME(MONTH,CreationTime) AS NAME_MONTH
FROM Sales.Orders

-- DDATETRUNK
SELECT 
OrderID,
CreationTime,
DATETRUNC(HOUR,CreationTime) AS TRUNK_MONTH
FROM Sales.Orders

--EOMONTH
-- returns the last day of month
SELECT 
OrderID,
CreationTime,
EOMONTH(CreationTime) AS end_month
FROM Sales.Orders


-- format and casting

--FORMAT
SELECT
OrderID,
CreationTime,
FORMAT(CreationTime,'MM-dd-yyyy') AS USA_FORMAT,
FORMAT(CreationTime,'dd-MM-yyyy') AS EU_FORMAT,
FORMAT(CreationTime, 'dd') dd,
FORMAT(CreationTime, 'ddd') ddd,
FORMAT(CreationTime, 'dddd') dddd
FROM Sales.Orders

-- task- Show creationTime using the following format:
-- Day Wed Jan Q1 2025 12:34:56 PM

SELECT
OrderID,
CreationTime,
'Day ' + FORMAT(CreationTime,'ddd-MMM')+
' Q' + DATENAME(QUARTER,CreationTime) +' '+ FORMAT(CreationTime,'yyyy hh:mm:ss tt')
FROM Sales.Orders

-- convert
SELECT
CONVERT(INT, '123') AS [String To Int],
CONVERT(DATE, '2034-03-23') AS [String To Date],
CreationTime,
CONVERT(DATE, CreationTime) AS [DateTime to Date convert],
CONVERT(VARCHAR, CreationTime, 32) AS [USA Std. Style:32],
CONVERT(VARCHAR, CreationTime, 34) AS [EURO Std. Style:34]
FROM Sales.Orders

--CAST
SELECT
CAST('123' AS INT) AS [STR TO INT],
CAST(123 AS VARCHAR) AS [INT TO VARCHAR / STRING],
CAST('2345-04-23' AS DATE) AS [STR TO DATE],
CAST('2345-04-23' AS datetime2) AS [STR TO DATETIME]


-- CALCULATIONS

-- DATEADD
SELECT
OrderDate,
DATEADD(YEAR, 2, OrderDate) AS [+ two years],
DATEADD(YEAR, -2, OrderDate) AS [- two years]
FROM sales.Orders

--DATEDIFF
-- TRansform birthday to age
SELECT
EmployeeID,
BirthDate,
DATEDIFF(YEAR,BirthDate,GETDATE()) AS [age]
FROM Sales.Employees

--findout the average shipping duration in days for each month
SELECT
MONTH(OrderDate) AS ORDERdate,
AVG(DATEDIFF(DAY,OrderDate,ShipDate)) AS [shipping duration in days]
FROM Sales.Orders
GROUP BY MONTH(OrderDate)

-- FIND THE NUMBER OF DAYS BETWEEN RACH ORDER AND THE PREVIOUS ORDER
SELECT 
OrderID,
OrderDate AS current_ordderDATE,
LAG(OrderDate) OVER (ORDER BY OrderDate) AS previous_orderDATE, 
DATEDIFF(DAY,LAG(OrderDate) OVER (ORDER BY OrderDate),OrderDate) [time2order]
FROM Sales.Orders

-- IS DATE
SELECT ISDATE('123') DATECHECK1,
ISDATE('2025-05-12') DATECHECK2,
ISDATE('12-05-2025') DATECHECK3,
ISDATE('2025') DATECHECK4,
ISDATE('05') DATECHECK5



--NUL FUNCTIONS--
--ISNULL
SELECT
ShipAddress,
ISNULL(ShipAddress, 'unknown') AS [null replaced]
FROM Sales.Orders

--COALESCE
SELECT
ShipAddress,
BillAddress,
COALESCE(ShipAddress,BillAddress, 'unknown') AS [null replaced]
FROM Sales.Orders

-- Find average score for the customers
SELECT
CustomerID,
Score,
AVG(Score) OVER() AVG_score,
AVG(COALESCE(Score,0)) OVER() avg_SCORE
FROM Sales.Customers

-- DISPLAY THE FULL NAME OF THE CUSTOMERS IN A SINGLR FIELD
-- by merging their first and last names,
-- and add 10 bonus points to each customers score
SELECT
CustomerID,
FirstName,
LastName,
FirstName + ' ' + COALESCE(LastName,'') AS [full name],
Score,
COALESCE(Score,0) + 10 [Score with bonus]
FROM Sales.Customers

-- sort the customer from lowest to the highest scores,
--with NULLs Appearing last
SELECT
CustomerID,
Score
FROM Sales.Customers
ORDER BY CASE WHEN Score IS NULL THEN 1 ELSE 0 END, Score


--NULLIF
--COMPAIR TWO EXPRESSION AND RETURNS:
-- NULL if they are equal
--first value if they are ot equal
--USE--
--1) Find the sales for each order by dividing the sales by the quantiy
SELECT
OrderID,
Sales,
Quantity,
Sales/NULLIF(Quantity,0) AS price
FROM Sales.Orders

--list of alldetails for cstomer who have not placed any order
SELECT
c.*,
o.OrderID
FROM Sales.Customers AS c
LEFT JOIN Sales.Orders AS o
ON c.CustomerID = o.CustomerID
WHERE o.CustomerID IS NULL

WITH Orders AS (
SELECT 1 ID, 'A' Category UNION
SELECT 2, NULL UNION
SELECT 3, '' UNION
SELECT 4, ' '
)
SELECT*
FROM Orders



--CASE STATEMENT--


--Generate a report showing the total sales for each category:
--High: If the sales higher than 50
--Medium: If the sales between 20 and 50
--Low: If the sales equal or lower than 20
--Sort the result from lowest to highest.

SELECT
category,
SUM(Sales) AS total_sales
FROM(
	SELECT
	OrderID,
	Sales,
	CASE
		WHEN Sales > 50 THEN 'HIGHER'
		WHEN Sales > 20 THEN 'MEDIUM'
		ELSE 'LOW'
	END AS category
	FROM Sales.Orders
)t
GROUP BY category
ORDER BY total_sales DESC
*/

--Count how many times each customer has made an order with sales greater than 30

SELECT
CustomerID,
 SUM(CASE 
	WHEN Sales > 30 THEN 1
	ELSE 0
	END) as Totle_Order,
	COUNT(*) Totle_order
FROM Sales.Orders
GROUP BY CustomerID
