/*
Proposition 6 :
Find all orders  from January 2016 to March 2016 
return from row 15 to 25 and the values Orderdate, unit price, productname and 
Description which calls on the scalar function that returns the length of time before product is shipped
use [Sales].[Order], [Production].[Product], [Sales].[OrderDetail]  use Northwinds2020TSQLV6
*/
USE Northwinds2020TSQLV6
DROP FUNCTION IF EXISTS [dbo].[Description]
GO
CREATE Function Description
(
    @Shippdate DATE,
    @OrderDate DATE

) 
RETURNS NVARCHAR(100)
AS 
Begin
        DECLARE @Differ NVARCHAR(10)
        DECLARE @Result NVARCHAR(100)
        SELECT @Differ = DATEDIFF(DAY, @OrderDate, @Shippdate)
        SET @Result = 'It took ' + @Differ +' day(s) before it gets shipped' 
        Return (@Result)
END
Go
SELECT O.OrderDate
, OD.UnitPrice
, P.ProductName 
,[dbo].[Description](O.ShipToDate, O.OrderDate) AS Description
FROM [Sales].[Order] AS O
    INNER JOIN [Sales].[OrderDetail] AS OD
        ON O.OrderId = OD.OrderId
        AND (O.OrderDate BETWEEN '20160101'AND '20160301')
    INNER JOIN [Production].[Product] AS P
        ON P.ProductId = OD.ProductId
ORDER BY P.UnitPrice ASC
OFFSET 15 ROWS FETCH NEXT 10 ROWS ONLY; 

/*return all orders done in 2015 and done by US employee and find the sales price of 
each order which is sales price minus the discounted price
find the number of orders, sales price and the order date of each order
*/

DROP FUNCTION IF EXISTS [dbo].[PriceofSale]
GO
CREATE Function PriceofSale
(
    @unitprice numeric(10,5),
    @quantity INT,
    @discountrate numeric(10,5)
    

) 
RETURNS numeric(10,5)
AS 
Begin
        DECLARE @Result numeric(10,5)
        DECLARE @discountprice numeric(10,5)
        DECLARE @regularprice numeric(10,5)

        SET @regularprice = @unitprice * @quantity
        SET @discountprice = @regularprice * @discountrate
        SET @Result = @regularprice - @discountprice
        Return @Result
END
Go

USE Northwinds2020
SELECT  O.OrderDate 
, Count(Month(O.OrderDate)) AS NumOrders
, SUM([dbo].[PriceofSale](od.UnitPrice, od.Quantity, od.DiscountPercentage)) AS SalesPrice
FROM Sales.[Order] AS O
    INNER JOIN Sales.OrderDetail AS OD
      ON O.OrderId = OD.OrderId
    INNER JOIN [HumanResources].[Employee] AS E
      ON E.EmployeeId = O.EmployeeId
WHERE  E.EmployeeCountry = N'USA' and Year(O.OrderDate) = '2015'
GROUP BY O.OrderDate;



