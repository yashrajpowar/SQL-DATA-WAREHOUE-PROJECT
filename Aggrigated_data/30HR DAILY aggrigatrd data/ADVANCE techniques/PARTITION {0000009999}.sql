-- Step 1: create partion function

CREATE PARTITION FUNCTION PartitionByYear (DATE)
AS RANGE LEFT FOR VALUES ('2023-12-31', '2024-12-31', '2025-12-31')


-- Query list all partition functions

SELECT
name,
function_id,
type,
type_desc,
boundary_value_on_right
FROM sys.partition_functions


-- STEP 2:CREATE FILES GROUPS

ALTER DATABASE SalesDB ADD FILEGROUP FG_2023;
ALTER DATABASE SalesDB ADD FILEGROUP FG_2024;
ALTER DATABASE SalesDB ADD FILEGROUP FG_2025;
ALTER DATABASE SalesDB ADD FILEGROUP FG_2026;

-- Query list all existing file group

SELECT
*
FROM sys.filegroups
WHERE TYPE = 'FG'


-- Step 3: Create .ndf files to eah Data group

ALTER DATABASE SalesDB ADD FILE
(
		NAME = P_2023, -- Logical Name
		FILENAME = 'E:\s work\SQL\SQL server express\MSSQL16.SQLEXPRESS\MSSQL\DATA\p_2023.ndf'
) TO FILEGROUP FG_2023;

ALTER DATABASE SalesDB ADD FILE
(
		NAME = P_2024, -- Logical Name
		FILENAME = 'E:\s work\SQL\SQL server express\MSSQL16.SQLEXPRESS\MSSQL\DATA\P_2024.ndf'
) TO FILEGROUP FG_2024;

ALTER DATABASE SalesDB ADD FILE
(
		NAME = P_2025, -- Logical Name
		FILENAME = 'E:\s work\SQL\SQL server express\MSSQL16.SQLEXPRESS\MSSQL\DATA\P_2025.ndf'
) TO FILEGROUP FG_2025;

ALTER DATABASE SalesDB ADD FILE
(
		NAME = P_2026, -- Logical Name
		FILENAME = 'E:\s work\SQL\SQL server express\MSSQL16.SQLEXPRESS\MSSQL\DATA\P_2026.ndf'
) TO FILEGROUP FG_2026;



-- chech the metadata

SELECT
	fg.name AS FilegroupName,
	mf.name AS LogicalFileName,
	mf.physical_name AS PhysicalFilePath,
	mf.size / 128 AS SizeInMB
FROM
     sys.filegroups fg
JOIN
     sys.master_files mf ON fg.data_space_id = mf.data_space_id
WHERE
     mf.database_id = DB_ID('SalesDB');




-- Step 4: Create partition scheme

CREATE PARTITION SCHEME SchemePartitionByYear
AS PARTITION PartitionByYear
TO (FG_2023, FG_2024, FG_2025, FG_2026)


-- Query lists all Partition Scheme

SELECT
	ps.name AS PartitionSchemeName,
	pf.name AS PartitionFunctionName,
	ds.destination_id AS PartitionNumber,
	fg.name AS FilegroupName
FROM sys. partition_schemes ps
JOIN sys. partition_functions pf 
     ON ps.function_id = pf.function_id
JOIN sys. destination_data_spaces ds 
     ON ps.data_space_id = ds.partition_scheme_id
JOIN sys. filegroups fg 
     ON ds.data_space_id = fg.data_space_id




-- Step 5: create partition table

CREATE TABLE Sales.OrdersPartitioned
(
	OrderID INT,
	OrderDate DATE,
	Sales INT
)ON SchemePartitionByYear (OrderDate)

INSERT INTO Sales.OrdersPartitioned VALUES (1, '2023-05-15', 100);
INSERT INTO Sales.OrdersPartitioned VALUES (2, '2024-05-15', 100);
INSERT INTO Sales.OrdersPartitioned VALUES (3, '2025-05-15', 100);
INSERT INTO Sales.OrdersPartitioned VALUES (4, '2026-05-15', 100);
INSERT INTO Sales.OrdersPartitioned VALUES (5, '2024-05-15', 100);

SELECT DISTINCT * FROM Sales.OrdersPartitioned

-- test if everythig i sworking fine

SELECT
	p.partition_number AS PartitionNumber,
	f.name AS PartitionFilegroup,
	p.rows AS NumberOfRows
FROM sys.partitions p
JOIN sys.destination_data_spaces dds ON p.partition_number = dds.destination_id
JOIN sys.filegroups f ON dds.data_space_id = f.data_space_id
WHERE OBJECT_NAME(p.object_id) = 'OrdersPartitioned';	