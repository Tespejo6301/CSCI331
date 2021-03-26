/*
Proposition 4:
Find how any many employees that got bonus more than $2000 by gender in USA
and sum up the bonus that are higher than $2000 by gender
use tables [Sales].[SalesTerritory], [Sales].[SalesPerson] and [HumanResources].[Employee]
and use AdventureWorks2017 as query
*/

USE AdventureWorks2017
DROP FUNCTION IF EXISTS [dbo].[Description]
GO
CREATE Function Description
(
    @GenderLetter NVARCHAR(2),
    @Bonus NVARCHAR(100)

) 
RETURNS NVARCHAR(100)
AS 
Begin
        DECLARE @Result NVARCHAR(100)
        DeCLARE @Gender NVARCHAR(10)
        SELECT @Gender = CASE
        When @GenderLetter = 'M' then 'Male'
        else 
        'Female'
        END
        SET @Result = @Gender + ' makes ' + '$' + @Bonus
        Return (@Result)
END
Go
SELECT Employee.Gender
    , COUNT(Employee.Gender) AS numPeople
    , SUM(SalesPerson.Bonus) AS TotalBonus
    , [dbo].[Description](Employee.Gender, SUM(SalesPerson.Bonus))
FROM [Sales].[SalesTerritory] AS Territory
    INNER JOIN [Sales].[SalesPerson] AS SalesPerson
        ON Territory.TerritoryID = SalesPerson.TerritoryID
        AND CountryRegionCode = 'US'
    INNER JOIN [HumanResources].[Employee] AS Employee
        ON  SalesPerson.BusinessEntityID = Employee.BusinessEntityID
        AND SalesPerson.Bonus > '2000'
 GROUP BY Employee.Gender
     


 
/*
Proposition 5:
 List all order dates. Customer Id, region code and Description which calls on the scalar function
  that calculates the days before it gets shipped
use [Sales].[SalesOrderHeader], [Sales].[SalesTerritory] and [Sales].[SalesTerritory] for table
 and use AdventureWork2017 for query
 */
USE AdventureWorks2017
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
        SET @Result =Concat( 'It took ', @Differ,' day(s) before it gets shipped') 
        Return (@Result)
END
Go
SELECT  SOH.OrderDate
, C.CustomerID
, T.CountryRegionCode
, [dbo].[Description](SOH.ShipDate, SOH.OrderDate) AS Description
FROM [Sales].[SalesOrderHeader] AS SOH
    INNER JOIN [Sales].[Customer] AS C
        ON SOH.CustomerID = C.CustomerID
        AND SOH.OrderDate > '20130101'
    INNER JOIN [Sales].[SalesTerritory] AS T
        ON C.TerritoryID = T.TerritoryID
        And NOT T.CountryRegionCode = 'US' 
GROUP By  SOH.OrderDate
,C.CustomerID
,T.CountryRegionCode
,SOH.ShipDate
,SOH.OrderDate
ORDER BY C.CustomerID;
       
           

