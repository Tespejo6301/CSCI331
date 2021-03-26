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
OFFSET 15 ROWS FETCH NEXT 10 ROWS ONLY
For JSON PATH
,Root(' Return all orders  from January 2016 to March 2016 ')
,INCLUDE_NULL_VALUES;