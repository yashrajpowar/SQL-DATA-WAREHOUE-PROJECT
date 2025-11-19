-- combine the data from employees and customers into one table
/*
SELECT 
c.FirstName,
c.LastName
FROM Sales.Customers AS c

UNION

SELECT 
e.FirstName,
e.LastName
FROM Sales.Employees AS e


-- UNION ALL 

SELECT
c.FirstName,
c.LastName
FROM Sales.Customers AS c

UNION ALL

SELECT
e.FirstName,
e.LastName
FROM Sales.Employees AS e


-- find the employees who are not the customers at the same time
-- EXCEPT SET
SELECT
c.FirstName,
c.LastName
FROM Sales.Customers AS c

EXCEPT

SELECT
e.FirstName,
e.LastName
FROM Sales.Employees AS e

-- FIND THE EMPLOEES WHO ARE ALSO CUSTOMERS
-- INTERSECT
SELECT
c.FirstName,
c.LastName
FROM Sales.Customers AS c

INTERSECT

SELECT
e.FirstName,
e.LastName
FROM Sales.Employees AS e


-- orders are stored in saperate tables ( Orders and OrderArchive )
-- combne all orders ino one report without duplicates.

SELECT 
'Orders' AS SourceTable,
[OrderID]
      ,[ProductID]
      ,[CustomerID]
      ,[SalesPersonID]
      ,[OrderDate]
      ,[ShipDate]
      ,[OrderStatus]
      ,[ShipAddress]
      ,[BillAddress]
      ,[Quantity]
      ,[Sales]
      ,[CreationTime]
FROM Sales.Orders

UNION

SELECT 
'OrdersArchive' AS SourceTable,
[OrderID]
      ,[ProductID]
      ,[CustomerID]
      ,[SalesPersonID]
      ,[OrderDate]
      ,[ShipDate]
      ,[OrderStatus]
      ,[ShipAddress]
      ,[BillAddress]
      ,[Quantity]
      ,[Sales]
      ,[CreationTime]
FROM Sales.OrdersArchive
ORDER BY OrderID
*/