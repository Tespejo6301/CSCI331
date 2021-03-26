
/*
Proposition 6:
Find top 10 order that has the highest total unit price and order id is atmost 10400
return orderdate, number of orders and totalunitprice which is sum all unit price
use table Sales.Order, and Sales.OrderDetail amd use query Nortwind2020
*/
USE Northwinds2020TSQLV6
SELECT  O.OrderId
, count(OD.OrderId) as NumOrders
, sum(UnitPrice) as totalUnitPrice

FROM [Sales].[Order] AS O
    INNER JOIN [Sales].[OrderDetail] AS OD
        ON OD.OrderId = O.OrderId
WHERE O.OrderId  <= '10400'
GROUP BY O.OrderId
ORDER BY totalUnitPrice DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;    

/*
 Proposition 7:
Find all the product that are Discontinued return all the supplier country and number of suppliers in country
use the tables [Production].[Product] and [Production].[Supplier] and query Northwinds2020TSQLV6
*/
USE Northwinds2020TSQLV6
SELECT  Supplier.SupplierCountry,
COUNT (Supplier.SupplierCountry) AS NumofSuppliers
FROM [Production].[Product] AS Product
INNER JOIN [Production].[Supplier] AS Supplier
    ON Product.SupplierId = Supplier.SupplierId
    AND Product.Discontinued = 1
  GROUP BY SupplierCountry; 

/*
 Proposition 8:
Find all orders place in 2014 and who ordered, the sum of TotalPrice and how many orders place
*/
SELECT O.OrderId
,CustomerId
,count(O.OrderId) AS numOrders
,sum(OD.UnitPrice * OD.Quantity) AS Price
FROM[Sales].[Order] AS O
    INNER JOIN [Sales].[OrderDetail] AS OD
     ON O.OrderId = OD.OrderId
WHERE YEAR(O.OrderDate) = 2014     
GROUP BY O.OrderId, CustomerId;
