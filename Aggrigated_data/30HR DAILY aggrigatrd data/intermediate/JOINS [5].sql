-- INNER JOIN

SELECT*
FROM customers
INNER JOIN orders
ON id = customer_id

-- LEFT JOIN
SELECT
c.id,
c.first_name,
c.country,
o.order_id,
o.customer_id,
o.sales
FROM customers AS c
LEFT JOIN orders AS o
ON id = customer_id 

-- RIGHT JOIN 
SELECT*
FROM customers
RIGHT JOIN orders
ON customer_id = id 

--FULL JOIN
SELECT *
FROM customers
FULL JOIN orders
ON id = customer_id 

-- left anti join
SELECT *
FROM customers
LEFT JOIN orders
ON id = customer_id
WHERE customer_id is null


-- right anti join

SELECT *
FROM customers
RIGHT join orders
ON id = customer_id
WHERE id IS NULL


-- FULL ANIT JOIN
SELECT *
FROM customers
FULL JOIN orders
ON id = customer_id
WHERE 
id IS NULL
OR
customer_id IS NULL

-- cross join
SELECT *
FROM customers
CROSS JOIN orders

-- multiple table join
/*Using SalesDB, Retrieve a list of all orders, along with
the related customer, product, and employee details.
For each order, display:
- Order ID
- Customer's name
- Product name
- sale amount
- product price
- salepersons name */

USE SalesDB

SELECT
O.OrderID,
O.Sales,
c.FirstName,
c.LastName,
p.Product AS product_name,
p.Price,
e.FirstName AS E_f_name,
e.LastName AS E_l_name
FROM Sales.Orders AS O
LEFT JOIN Sales.Customers AS c
ON o.CustomerID = c.CustomerID
LEFT JOIN Sales.Products AS p
ON o.ProductID = p.ProductID
LEFT JOIN Sales.Employees AS e
ON o.SalesPersonID = e.EmployeeID
