/* 
Proposition 5:
return all the employee's sales quota and fullname from quarter 1
*/
USE AdventureWorksDW2017
SELECT Quota.CalendarYear
    , CONCAT(Employee.LastName, N', ',  Employee.FirstName) AS FullName
    ,Quota.SalesAmountQuota
FROM [dbo].[FactSalesQuota] as Quota
    INNER JOIN [dbo].[DimEmployee] as Employee
    ON Quota.EmployeeKey = Employee.EmployeeKey
        AND Quota.CalendarQuarter = 1 





