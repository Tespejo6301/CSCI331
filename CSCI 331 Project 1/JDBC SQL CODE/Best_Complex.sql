DROP FUNCTION IF EXISTS [HumanResources].[getRetirementYears]
GO
CREATE Function [HumanResources].[getRetirementYears]
(
    @Age INT
) 
RETURNS INT
AS 
    Begin
         RETURN CASE
            WHEN @AGE >= 65
                THEN - 1
            ELSE 
                65 - @AGE
            END       
END
Go

SELECT E.EmployeeFirstName
, E.EmployeeLastName
, E.HireDate 
, E.EmployeeID
, E.BirthDate  
, TotalOrders = COUNT(O.Orderid)
, TotalSales = SUM(OD.Quantity * OD.UnitPrice)
, YearUntilRetirement = [HumanResources].[getRetirementYears](abs(DateDiff(Year, getDate(), E.BirthDate)))      
FROM [HumanResources].[Employee] AS E
    INNER JOIN [Sales].[Order] AS O
        ON E.EmployeeId = O.EmployeeId
    INNER JOIN [Sales].[OrderDetail] AS OD
        ON O.Orderid =  OD.Orderid
Group By E.EmployeeFirstName
, E.EmployeeLastName
, E.HireDate 
, E.EmployeeID
, E.BirthDate         