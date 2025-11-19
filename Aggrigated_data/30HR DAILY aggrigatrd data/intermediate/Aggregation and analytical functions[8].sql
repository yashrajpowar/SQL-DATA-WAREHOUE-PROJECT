-- Aggregate Functions--
/*
-- find the total number of orders
-- Find Total sales of all orders
-- find average sales of all orders
SELECT
COUNT(*) AS TotalNoOfOrders,
SUM(Sales) AS TotalSales,
AVG(Sales) AS AVG_sales,
MAX(Sales) AS highest_sale,
MIN(Sales) AS min_sale
FROM Orders


-- WINDOWS FUNCTION--
--find total sales across all orders
SELECT
ProductID,
SUM(Sales) AS Total_Sales
FROM Sales.Orders
GROUP BY ProductID

--find the total sale for each product additionally provide details such order id and order dete
SELECT
OrderID,
OrderDate,
ProductID,
SUM(Sales) OVER(PARTITION BY ProductID) AS [total sales by product]
FROM Sales.Orders

-- rank each order based on their sales from higest to lowest additionally provide details such order id and order dete
SELECT
OrderID,
OrderDate,
Sales,
RANK() OVER(ORDER BY Sales DESC) AS Rank_Sales
FROM Sales.Orders

-- FRAME CLAUSES
SELECT
OrderID,
OrderDate,
OrderStatus,
Sales,
SUM(Sales) OVER(PARTITION BY OrderStatus ORDER BY OrderDate
ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING) AS TOTAL_SALES
FROM Sales.Orders

-- rank customers based on their total sales
SELECT
CustomerID,
SUM(Sales) AS total_sales,
RANK() OVER(ORDER BY SUM(Sales) DESC)
FROM Sales.Orders
GROUP BY CustomerID

--WINDOW AGGREGATE FUNCTION
--Find the total number oF Customers
-- Additionally provide All customers Details
SELECT
*,
COUNT(*) over() AS total_no_of_customers,
COUNT(Score) over() AS ScoreCount,
COUNT(Country) over() AS countries
FROM Sales.Customers

--Check whether the table 'Orders' contains any duplicate rows
SELECT
OrderID,
COUNT(*) OVER (PARTITION BY OrderID) CHECKDUPLICATE
FROM Sales.Orders
-- only see duplicate values
SELECT
*
FROM (SELECT
OrderID,
COUNT(*) OVER (PARTITION BY OrderID) CHECKDUPLICATE
FROM Sales.Orders
)t WHERE CHECKDUPLICATE > 1


--Find the total sales across all orders
--And the total sales for each product
--Additionally provide details such order Id, order date
SELECT
OrderID,
OrderDate,
Sales,
ProductID,
SUM(Sales) OVER () TotalSales,
SUM(Sales) OVER(PARTITION BY ProductID) AS TOTALsalesBYproduct
FROM Sales. Orders

-- Find the percentage contribution of each product's sales to the total sales
SELECT
OrderID,
ProductID,
Sales,
SUM(Sales) OVER() AS TotalSa1es,
ROUND(CAST(Sales AS FLOAT) / SUM(Sales) OVER() * 100, 2) AS percentage_total -- CHANGED THE sALES COULMN INTO FLOAT
FROM Sales.Orders


--Find all orders where sales are higher than the average sales across all orders
SELECT
*
FROM (
	SELECT
	OrderID,
	ProductID,
	Sales,
	AVG(Sales) OVER() AvgSa1es
	FROM Sales.Orders
)t 
WHERE Sales > AvgSa1es

-- Show the employees who have the highest salaries
SELECT
*
FROM(
	SELECT
	*,
	MAX(Salary) OVER() HighestSalary
	FROM Sales.Employees
)t 
   WHERE Salary = HighestSalary
   
-- Calculate moving average of sales for each product over time
-- Calculate moving average of sales for each product over time, INCLUDING ONLY THE NEXT ORDER
SELECT
	OrderID,
	ProductID,
	OrderDate,
	Sales,
AVG(Sales) OVER (PARTITION BY ProductID) AvgByProduct,
AVG(Sales) OVER (PARTITION BY ProductID ORDER BY OrderDate) MovingAvg,
AVG(Sales) OVER (PARTITION BY ProductID ORDER BY OrderDate ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING) RollingAverage
FROM Sales.Orders


-- Rank the orders based on their sales from highest to lowest
SELECT
	OrderID,
	ProductID,
	Sales,
	ROW_NUMBER() OVER(ORDER BY Sales DESC) SalesRank_Row,
	RANK() OVER(ORDER BY Sales DESC) SalesRank_Rank,
	DENSE_RANK() OVER(ORDER BY Sales DESC) SalesRank_DEMSE
FROM Sales.Orders

--Find the top highest sales for each product
SELECT
*
FROM(
	SELECT
		OrderID,
		ProductID,
		Sales,
	ROW_NUMBER() OVER (PARTITION BY ProductID ORDER BY Sales DESC) AS RankByProduct
	FROM Sales.Orders
) t 
	WHERE RankByProduct = 1
	
-- Find the lowest 2 customers based on their total sales
SELECT
*
FROM(
	SELECT
		CustomerID,
		SUM(Sales) TotalSa1es,
		ROW_NUMBER() OVER (ORDER BY SUM(Sales)) RanklowCustomers
	FROM Sales.Orders
	GROUP BY CustomerID
) t 
	WHERE RanklowCustomers <= 2

-- ASIGN UNIQUE ID TO 'ORDER.ARCHIVE'TABLE

SELECT
ROW_NUMBER() OVER (ORDER BY Orderid, OrderDate) AS UNIQUEid,
*
FROM Sales.OrdersArchive

-- Identify duplicate rows in the table 'Orders Archive'
-- and return a clean result without any duplicates
SELECT
*
FROM(
	SELECT
	*,
	ROW_NUMBER() OVER(PARTITION BY OrderID ORDER BY CreationTime) CT
	FROM Sales.OrdersArchive
) t
	WHERE CT = 1
	

-- NTILE
SELECT
OrderID,
Sales,
NTILE(1) OVER(ORDER BY Sales DESC) OneBUCKET,
NTILE(2) OVER(ORDER BY Sales DESC) TwoBUCKET,
NTILE(3) OVER(ORDER BY Sales DESC) threeBUCKET,
NTILE(4) OVER(ORDER BY Sales DESC) fourBUCKETh
FROM Sales.Orders

--Segment all orders into 3 categories:high medium and low sales.
SELECT
*,
 CASE 
   WHEN BUCKETS = 1 THEN 'HIGH'
   WHEN BUCKETS = 2 THEN 'MEDIUM'
   WHEN BUCKETS = 3 THEN 'LOW'
 END as salesSTATUS
FROM(
SELECT
OrderID,
Sales,
NTILE(3) OVER(ORDER BY Sales DESC) BUCKETS
FROM Sales.Orders
) t

-- Find the products that fall within the highest 40% of the prices
SELECT
*,
CONCAT(descRNK * 100, '%') dISTrnkPerc
FROM(
	SELECT
		Product,
		Price,
		CUME_DIST() OVER (ORDER BY Price DESC) descRNK
	FROM Sales.Products
) t
	WHERE descRNK <= 0.4

--Analyze the month-over-month (MOM) performance
--by finding the percentage change in sales
--between the current and previous month
SELECT
*,
currentMONTHLY_sales - P_M_Sales AS diff,
ROUND(CAST(currentMONTHLY_sales - P_M_Sales AS FLOAT) / P_M_Sales * 100, 2) AS PER_TOTAL 
FROM(
SELECT
MONTH(OrderDate) Month_,
SUM(Sales) AS currentMONTHLY_sales,
LAG(SUM(Sales)) OVER (ORDER BY MONTH(OrderDate)) AS P_M_Sales
FROM Sales.Orders
GROUP BY MONTH(OrderDate)
) t

--In order to analyze customer loyalty,
--rank customers based on the average days between their orders
SELECT
CustomerID,
AVG(Order_gap) AVG_DAYS,
ROW_NUMBER() OVER(ORDER BY COALESCE(AVG(Order_gap),9999))
FROM(
	SELECT
	OrderID,
	CustomerID,
	OrderDate,
	LEAD(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate) AS led_order,
	DATEDIFF(DAY, OrderDate , LEAD(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate)) Order_gap
	FROM Sales.Orders
) t
	GROUP BY CustomerID
	*/
--Find the lowest and highest sales for each product
SELECT
	OrderID,
	ProductID,
	Sales,
	FIRST_VALUE (Sales) OVER (PARTITION BY ProductID ORDER BY Sales) LowestSa1es,
	LAST_VALUE (Sales) OVER( PARTITION BY ProductID ORDER BY Sales 
	ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) HIGESTsales
FROM Sales.Orders
-- CAN ALSO USE MIN AND MAX FUCTION TO SOLVE THE TASK