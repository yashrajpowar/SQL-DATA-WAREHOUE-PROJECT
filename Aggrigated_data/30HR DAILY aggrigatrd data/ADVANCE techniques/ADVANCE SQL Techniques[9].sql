
-- advance SQL --

--# SUBQUESRIES #--

-- LOCATION | CLAUSES --

-- FROM subquery

/*Task: Find the products that have a price
higher than the average price of all products */

--Main Query
SELECT 
*
FROM(
    -- Subquery
	SELECT
	ProductID,
	Price,
	AVG(Price) OVER() avg_p
	FROM Sales. Products
) t
	WHERE
		Price > avg_p

-- select subquery
--Show the product IDs, names, prices and total number of orders.
SELECT
ProductID,
Product,
Price,
(SELECT COUNT(*) TOTAL_orders FROM Sales.Orders) AS total_orders
FROM Sales. Products


-- JOIN subquery
--Show all customer details and find the total orders for each customer.
SELECT 
c.*,
o.total_order -- I did it beacause customer id column was showing twice
FROM Sales.Customers c
LEFT JOIN(
	SELECT 
	CustomerID,
	COUNT(*) total_order
	FROM Sales.Orders
	GROUP BY CustomerID
) o
ON c.CustomerID = o.CustomerID


--WHERE subqueries
--Comparison oprators

--Find the products that have a price higher than the average price of all products.
SELECT
	ProductID,
	Price,
	(SELECT AVG(Price) FROM Sales. Products) AvgPrice
	FROM Sales.Products
WHERE Price > (SELECT AVG(Price) FROM Sales.Products ) 

--Logical oprator
-- IN

--- Show the details of orders made by customers in Germany
SELECT
*
FROM Sales.Orders
WHERE CustomerID IN (SELECT
					CustomerID
					FROM Sales.Customers
					WHERE Country = 'Germany')

-- ANY | ALL
--Find female employees whose salaries are greater than the salaries of any male employees

SELECT
EmployeeID,
FirstName,
Salary
FROM Sales.Employees
WHERE Gender = 'F'
AND Salary > ANY (SELECT Salary FROM Sales.Employees WHERE Gender = 'M')

SELECT Salary FROM Sales.Employees WHERE Gender = 'M'

--Find female employees whose salaries are greater than the salaries of any male employees

SELECT
EmployeeID,
FirstName,
Salary
FROM Sales.Employees
WHERE Gender = 'F'
AND Salary > ALL (SELECT Salary FROM Sales.Employees WHERE Gender = 'M')

SELECT FirstName, Salary  FROM Sales.Employees WHERE Gender = 'M'


-- correlated and non-correlated subqueries

--Show all customer details and find the total orders for each customer.
SELECT
	*,
	(SELECT COUNT(*) FROM Sales.Orders o WHERE O.CustomerID = C.CustomerID) TotalSa1es
FROM Sales.Customers c


-- EXISTS
-- Show the details of orders made by customers in Germany

SELECT
* 
FROM Sales.Orders o
WHERE EXISTS (SELECT
				*
				FROM Sales.Customers c
				WHERE Country = 'Germany'
				AND o.CustomerID = c.CustomerID)


-- # CTE # --

-- Standalone CTE

--#1 STEP: Find the total sales per customer.

WITH CTE_TOTAL_SALES AS
(
	SELECT
	CustomerID,
	SUM(Sales) AS TotalSales
	FROM Sales. Orders
	GROUP BY CustomerID
)		
-- Main Query
SELECT
	c.CustomerID,
	c.FirstName,
	c.LastName,
	cts.TotalSales
FROM Sales.Customers c
LEFT JOIN CTE_TOTAL_SALES AS cts
ON cts.CustomerID = c.CustomerID


-- Multiple standalone CTE
--#1 STEP: Find the total sales per customer.

WITH CTE_TOTAL_SALES AS
(
	SELECT
	CustomerID,
	SUM(Sales) AS TotalSales
	FROM Sales. Orders
	GROUP BY CustomerID
)
--#2 STEP: Find the last order date per customer.
, CTE_LAST_ORDER AS
(SELECT
CustomerID,
MAX(OrderDate) AS last_order
FROM Sales.Orders
GROUP BY CustomerID
)
-- Main Query
SELECT
	c.CustomerID,
	c.FirstName,
	c.LastName,
	cts.TotalSales,
	clo.last_order
FROM Sales.Customers c
LEFT JOIN CTE_TOTAL_SALES AS cts
ON cts.CustomerID = c.CustomerID
LEFT JOIN CTE_LAST_ORDER AS clo
ON clo.CustomerID = c.CustomerID

-- Nested CTE


--#1 STEP: Find the total sales per customer.
--#2 STEP: Find the last order date per customer.
--#3 STEP: Rank Customers based on total sales per customer.


--#1 STEP: Find the total sales per customer.

WITH CTE_TOTAL_SALES AS
(
	SELECT
	CustomerID,
	SUM(Sales) AS TotalSales
	FROM Sales. Orders
	GROUP BY CustomerID
)
--#2 STEP: Find the last order date per customer.
, CTE_LAST_ORDER AS
	(SELECT
	CustomerID,
	MAX(OrderDate) AS last_order
	FROM Sales.Orders
	GROUP BY CustomerID
)
--#3 STEP: Rank Customers based on total sales per customer.
, CTE_CUSTOMER_RANK AS
(
	SELECT 
	CustomerID,
	TotalSales,
	RANK() OVER( ORDER BY TotalSales DESC) AS customer_RANK
	FROM CTE_TOTAL_SALES
)
-- Main Query
SELECT
	c.CustomerID,
	c.FirstName,
	c.LastName,
	cts.TotalSales,
	clo.last_order,
	ccr.customer_RANK
FROM Sales.Customers c
LEFT JOIN CTE_TOTAL_SALES AS cts
ON cts.CustomerID = c.CustomerID
LEFT JOIN CTE_LAST_ORDER AS clo
ON clo.CustomerID = c.CustomerID
LEFT JOIN CTE_CUSTOMER_RANK AS ccr
ON ccr.CustomerID = c.CustomerID


--#1 STEP: Find the total sales per customer.
--#2 STEP: Find the last order date per customer.
--#3 STEP: Rank Customers based on total sales per customer.
--#4 STEP: Segment customers based on their total sales.

--#1 STEP: Find the total sales per customer.

WITH CTE_TOTAL_SALES AS
(
	SELECT
	CustomerID,
	SUM(Sales) AS TotalSales
	FROM Sales. Orders
	GROUP BY CustomerID
)
--#2 STEP: Find the last order date per customer.
, CTE_LAST_ORDER AS
	(SELECT
	CustomerID,
	MAX(OrderDate) AS last_order
	FROM Sales.Orders
	GROUP BY CustomerID
)
--#3 STEP: Rank Customers based on total sales per customer.
, CTE_CUSTOMER_RANK AS
(
	SELECT 
	CustomerID,
	TotalSales,
	RANK() OVER( ORDER BY TotalSales DESC) AS customer_RANK
	FROM CTE_TOTAL_SALES
)
--#4 STEP: Segment customers based on their total sales.
, CTE_CUSTOMER_SEGMENT AS
(
SELECT
CustomerID,
TotalSales,
CASE WHEN TotalSales > 100 THEN 'HIGH'
     WHEN TotalSales >= 90 THEN 'MEDIUM'
	 WHEN TotalSales > 50 THEN 'LOW'
	 ELSE 'VERY LOW'
	 END AS customer_SEGMENT
	 FROM CTE_TOTAL_SALES
)

-- Main Query
SELECT
	c.CustomerID,
	c.FirstName,
	c.LastName,
	cts.TotalSales,
	clo.last_order,
	ccr.customer_RANK,
	ccs.customer_SEGMENT
FROM Sales.Customers c
LEFT JOIN CTE_TOTAL_SALES AS cts
ON cts.CustomerID = c.CustomerID
LEFT JOIN CTE_LAST_ORDER AS clo
ON clo.CustomerID = c.CustomerID
LEFT JOIN CTE_CUSTOMER_RANK AS ccr
ON ccr.CustomerID = c.CustomerID
LEFT JOIN CTE_CUSTOMER_SEGMENT AS ccs
ON ccs.CustomerID = c.CustomerID


-- RECURSIVE CTE

-- Generate a Sequence of Numbers from 1 to 20


WITH Series AS
(
	--
	SELECT 
	1 AS MYnumber
	UNION ALL
	--
	SELECT
	MYnumber + 1
	FROM Series
	WHERE MYnumber < 20
)
-- MAIN QUERY
SELECT
	*
FROM Series


-- Show the employee hierarchy by displaying each employee's level within the organization.

WITH CTE_EMP_HIERERCHY AS
(
	SELECT
		EmployeeID,
		FirstName,
		ManagerID,
		1  AS LEVEL
	FROM Sales.Employees
	WHERE ManagerID  IS NULL
	UNION ALL

	SELECT
	    e.EmployeeID,
		e.FirstName,
		e.ManagerID,
		LEVEL + 1
	FROM Sales.Employees e
	INNER JOIN CTE_EMP_HIERERCHY ceh
	ON e.ManagerID = ceh.EmployeeID
)

SELECT
*
FROM CTE_EMP_HIERERCHY


-- data sequerity in VIEW -- 

/*Provide a view for the EU Sales Team
that combines details from all tables
and excludes data related to the USA.*/

CREATE VIEW Sales.V_FOR_ANALYST AS
(
	SELECT
		o.OrderID,
		o.OrderDate,
		p.Product,
		p.Category,
		COALESCE(c.FirstName,'') +''+ COALESCE(c.LastName,'') CustomerName,
		c.Country CustomerCountry,
		COALESCE(e.FirstName,'') +''+ COALESCE(e.LastName,'') SalesName,
		e.Department,
		o.Sales,
		o.Quantity
	FROM Sales.Orders o
	LEFT JOIN Sales. Products p
	ON p. ProductID = o. ProductID
	LEFT JOIN Sales. Customers c
	ON c.CustomerID = o.CustomerID
	LEFT JOIN Sales. Employees e
	ON e. EmployeeID = o.SalesPersonID
	WHERE c.Country != 'USA'
)


--	CTAS TABLE --


SELECT
	DATENAME (month, OrderDate) OrderMonth,
	COUNT(OrderID) TotalOrders
INTO Sales.Monthly_orders
FROM Sales.Orders
GROUP BY DATENAME (month, OrderDate)

SELECT * FROM Sales.Monthly_orders


--  STORED PROCEDURE --

--Step 1: Write a Query
-- For US Customers Find the Total Number of Customers and the Average Score

SELECT
COUNT(*) TotalCustomers,
AVG(Score) AvgScore 
FROM Sales. Customers
WHERE Country = 'USA'

-- Step 2: convert this query into stored rocedure

CREATE PROCEDURE GetCustomerSummary AS
BEGIN
	SELECT
	COUNT(*) TotalCustomers,
	AVG(Score) AvgScore
	FROM Sales. Customers
	WHERE Country = 'USA'
END
 
-- Step 3: exicute the stored procedure

EXEC GetCustomerSummary

-- PARAMETER -- 
-- TO MAKE QUERY DYNAMIC

ALTER PROCEDURE GetCustomerSummary @Country NVARCHAR (50) AS
BEGIN
	SELECT
	COUNT(*) TotalCustomers,
	AVG(Score) AvgScore
	FROM Sales. Customers
	WHERE Country = @Country

	--Find the total Nr. of Orders and Total Sales

	SELECT
	COUNT(OrderID) TotalOrders,
	SUM(Sales) TotalSales
	FROM Sales.Orders o	
	JOIN Sales.Customers c
	ON c.CustomerID = o.CustomerID
	WHERE c.Country = @Country
END

EXEC GetCustomerSummary @Country = 'USA'



-- VARIABLE --
-- TO MAKE QUERY DYNAMIC

ALTER PROCEDURE GetCustomerSummary @Country NVARCHAR (50) AS
BEGIN
DECLARE @TotalCustomers INT, @AvgScore FLOAT
	SELECT
	@TotalCustomers = COUNT(*) ,
	@AvgScore = AVG(Score) 
	FROM Sales. Customers
	WHERE Country = @Country

	PRINT 'Total Customers from ' + @Country + ':' + CAST(@TotalCustomers AS NVARCHAR);
    PRINT 'Average Score from ' + @Country + ':' + CAST(@AvgScore AS NVARCHAR);

	--Find the total Nr. of Orders and Total Sales

	SELECT
	COUNT(OrderID) TotalOrders,
	SUM(Sales) TotalSales
	FROM Sales.Orders o	
	JOIN Sales.Customers c
	ON c.CustomerID = o.CustomerID
	WHERE c.Country = @Country
END

EXEC GetCustomerSummary @Country = 'USA'

-- control flow -- 
-- ( using IF ELSE ) --

ALTER PROCEDURE GetCustomerSummary @Country NVARCHAR (50) = 'USA' AS
	BEGIN
	-- ERRORHANDLING ( TRY CATCH )
	BEGIN TRY
		DECLARE @TotalCustomers INT, @AvgScore FLOAT

		-- prepare and clean up data

			IF EXISTS (SELECT 1 FROM Sales.Customers WHERE Score IS NULL AND Country = @Country)
			BEGIN
				PRINT('UPDATE NULL SCORE TO 0');  
				UPDATE Sales.Customers
				SET Score = 0
				WHERE SCORE IS NULL AND Country = @Country;
			END

			ELSE
			BEGIN
			PRINT( 'NO NULL FOUND IN SCORE');
			END


		-- genrating report
		SELECT
			@TotalCustomers = COUNT(*) ,
			@AvgScore = AVG(Score) 
		FROM Sales. Customers
		WHERE Country = @Country

		PRINT 'Total Customers from ' + @Country + ':' + CAST(@TotalCustomers AS NVARCHAR);
		PRINT 'Average Score from ' + @Country + ':' + CAST(@AvgScore AS NVARCHAR);

			--Find the total Nr. of Orders and Total Sales

		SELECT
			COUNT(OrderID) TotalOrders,
			SUM(Sales) TotalSales,
			1/0
		FROM Sales.Orders o	
		JOIN Sales.Customers c
		ON c.CustomerID = o.CustomerID
		WHERE c.Country = @Country

	END TRY
	BEGIN CATCH
		PRINT('An error occured.');
		PRINT('Error Message:'+ ERROR_MESSAGE());
		PRINT('Error Number:'+ CAST(ERROR_NUMBER() AS NVARCHAR));
		PRINT('Error Line: '+ CAST(ERROR_LINE() AS NVARCHAR));
		PRINT('Error Procedure ' + ERROR_PROCEDURE());
	END CATCH

END
GO

EXEC GetCustomerSummary
*/ 


--===== TRIGGERS ====--

CREATE TRIGGER trg_AfterInsertEmployees ON Sales.Employees
AFTER INSERT
AS
BEGIN
INSERT INTO Sales.EmployeeLogs (EmployeeID, LogMessage, LogDate)
	SELECT
		EmployeeID,
		'New Employee Added =' + CAST(EmployeeID AS VARCHAR),
		GETDATE()
	FROM INSERTED -- VERTUAL TABLE
END


CREATE TABLE Sales.EmployeeLogs(
LogID INT IDENTITY(1,1) PRIMARY KEY,
EmployeeID INT,
LogMessage VARCHAR (255),
LogDate DATE
)

SELECT * FROM Sales.EmployeeLogs

SELECT * FROM Sales.Employees

INSERT INTO Sales.Employees
VALUE
(6, 'YASH', 'POWAR', 'SCM', '2002-07-13', 'M', 100000, 5)