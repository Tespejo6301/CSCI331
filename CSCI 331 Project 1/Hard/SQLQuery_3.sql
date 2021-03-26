USE AdventureWorksDW2017
DROP FUNCTION IF EXISTS [dbo].[OtherCost]
GO
CREATE Function OtherCost
(
    @TotalCost money,
    @StandardCost money
) 
RETURNS money
AS 
Begin
        DECLARE @OtherCost money
        SET @OtherCost = @TotalCost - @StandardCost
        Return (@OtherCost)
END
Go       
USE AdventureWorksDW2017
DECLARE @mindate AS INT = (SELECT MIN(OrderDateKey)
                            FROM [dbo].[FactResellerSales])

SELECT  Product.ProductAlternateKey
    , count(Employee.EmployeeKey) AS numorders
    , Employee.LastName
    , Employee.FirstName
    , sum(Reseller.TotalProductCost) AS sumTotalCost
    , sum(Reseller.ProductStandardCost) AS sumStandardCost
    , [dbo].[OtherCost](sum(Reseller.TotalProductCost), sum(Reseller.ProductStandardCost)) AS OtherCost 
FROM [dbo].[FactResellerSales] AS Reseller
    INNER JOIN [dbo].[DimProduct] AS Product
        ON Reseller.ProductKey = Product.ProductKey
    INNER JOIN [dbo].[DimEmployee] AS Employee
        ON Reseller.EmployeeKey = Employee.EmployeeKey
            AND Reseller.OrderDateKey = @mindate
WHERE   (Reseller.TotalProductCost - Reseller.ProductStandardCost) > 0   
GROUP BY Product.ProductAlternateKey
    , Employee.LastName
    , Employee.FirstName
For JSON PATH       
    , Root('Cost of product for all orders done by a particular Employee ') 
    , INCLUDE_NULL_VALUES          




