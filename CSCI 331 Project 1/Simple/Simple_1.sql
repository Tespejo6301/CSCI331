/*
 Proposition 1: Create a query that returns the orderdate, orderid and customer id of customer who order in 2014
 use Sales.Orders table and Nortwind2020
 */
USE Northwinds2020TSQLV6
SELECT DISTINCT OD.ProductId
, O.OrderDate
,O.OrderId
, O.CustomerId
FROM [Sales].[Order] AS O
    INNER JOIN [Sales].[OrderDetail] AS OD
        ON O.OrderId = OD.OrderId
Where OrderDate >= '20140101' AND OrderDate < '20150101'
ORDER BY OD.ProductId
FOR JSON PATH
, ROOT('Orders done in 2014')
, INCLUDE_NULL_VALUES;


/*
Proposition 2: return the Suppplier, id CompanyName, and City  who's supply comes from Japan ordered by their city
use Product Supplier Table from Nortwind2020 
*/
USE Northwinds2020TSQLV6
Select SupplierId
, SupplierCompanyName
, SupplierCity 
FROM [Production].[Supplier]
WHERE SupplierCountry = 'Japan';