/*
-- INDEXES--

-- CREATE INDEX

SELECT 
*
INTO Sales.DBCustomers 
FROM Sales.Customers



CREATE CLUSTERED INDEX idx_DBCustomers_CustomerID 
ON Sales.DBCustomers (CustomerID)

CREATE NONCLUSTERED INDEX idx_DBCustomers_LastName
ON Sales.DBCustomers (LastName)

CREATE INDEX idx_DB_Customers_FirstName
ON Sales.DBCustomers (FirstName)

CREATE INDEX idx_DBCustomers_CountryScore
ON Sales.DBCustomers (Country, Score)

CREATE CLUSTERED COLUMNSTORE INDEX idx_DBCustomers_CS
ON Sales.DBCustomers

DROP INDEX [idx_DBCustomers_CustomerID] ON Sales.DBCustomers

CREATE NONCLUSTERED COLUMNSTORE INDEX idx_DBCustomers_CS_FirstName
ON Sales.DBCustomers (FirstName)


USE AdventureWorksDW2022
--HEAP
SELECT*
INTO FactInternetSales_HP
FROM FactInternetSales

RowStore
SELECT*
INTO FactInternetSales_RS
FROM FactInternetSales

CREATE CLUSTERED INDEX idx_FactInternetSales_RS_PK
ON FactInternetSales_RS (SalesOrderNumber, SalesOrderLineNumber)

-- Columnstore
SELECT*
INTO FactInternetSales_CS
FROM FactInternetSales

CREATE CLUSTERED COLUMNSTORE INDEX idx_FactInternetSales_CS_PK
ON FactInternetSales_CS
*/

-- UNIQUE INDEX

SELECT * FROM Sales.Products

CREATE UNIQUE NONCLUSTERED INDEX idx_Products_Product
ON Sales.Products (Product)

-- FILTERED INDEX

SELECT * FROM Sales.Customers
WHERE Country = 'USA'

CREATE NONCLUSTERED INDEX idx_Customers_Country
ON Sales.Customers (Country)
WHERE Country = 'USA'

-- list of all indes
Sp_helpindex '[Sales].[DBCustomers]'

-- monnitor all index
SELECT
	tbl.name AS TableName,
	idx.name AS IndexName,
	idx. type_desc AS IndexType,
	idx.is_primary_key AS IsPrimaryKey,
	idx.is_unique AS IsUnique,
	idx.is_disabled AS IsDisabled,
	s.user_seeks,
	s.user_scans,
	s.user_lookups,
	s.user_updates,
	COALESCE (s.last_system_seek,s.last_system_scan) AS HHH
FROM sys. indexes idx
JOIN sys. tables tbl
ON idx.object_id = tbl.object_id
LEFT JOIN sys.dm_db_index_usage_stats s
ON s.object_id = idx.object_id
ORDER BY tbl.name, idx.name

SELECT * FROM sys.dm_db_index_usage_stats


-- MONITOR DUPLICATE INDEXES

SELECT
	tbl.name AS TableName,
	col.name AS IndexColumn,
	idx.name AS IndexName,
	idx. type_desc AS IndexType,
	COUNT (*) OVER (PARTITION BY tbl.name, col.name) ColumnCount
FROM sys.indexes idx
JOIN sys. tables tbl ON idx. object_id = tbl.object_id
JOIN sys. index_columns ic ON idx.object_id = ic.object_id AND idx.index_id = ic.index_id
JOIN sys. columns col ON ic.object_id = col.object_id AND ic.column_id = col.column_id
ORDER BY ColumnCount DESC

-- UPDATE STATISTICS

SELECT
SCHEMA_NAME(t.schema_id) AS SchemaName,
t.name AS TableName,
s.name AS StatisticName,
sp.last_updated As LastUpdate,
DATEDIFF(day, sp.last_updated, GETDATE()) As LastUpdateDay,
sp.rows AS 'Rows',
sp.modification_counter AS ModificationsSinceLastUpdate
FROM sys. stats AS s
JOIN sys. tables t
ON s.object_id = t.object_id
CROSS APPLY sys.dm_db_stats_properties(s.object_id, s.stats_id) AS sp
ORDER BY
sp.modification_counter DESC;








