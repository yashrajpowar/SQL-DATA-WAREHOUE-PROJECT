SELECT 
*
FROM FactResellerSales
WHERE CarrierTrackingNumber = '4911-403C-98'

CREATE NONCLUSTERED INDEX IND_factResellerSales_CTA 
ON FactResellerSales (CarrierTrackingNumber)