SELECT
*
FROM [dbo].[FactResellerSales]

SELECT
*
INTO FactResellerSales_HI
FROM FactResellerSales

SELECT 
*
FROM FactResellerSales_HI
WHERE CarrierTrackingNumber = '4911-403C-98'



