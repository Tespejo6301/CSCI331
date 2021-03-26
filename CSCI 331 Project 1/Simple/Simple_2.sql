/*
Proposition 3:
return top 5 employee's with the highest bonus and their gender 
use the Sales.SalesPerson table and the query adventureworkds2017
*/
USE AdventureWorks2017
SELECT TOP(5)Bonus
, SalesPerson.BusinessEntityID
, SalesPerson.SalesQuota 
, Employee.Gender
FROM [Sales].[SalesPerson] AS SalesPerson
    INNER JOIN [HumanResources].[Employee] as Employee
        ON SalesPerson.BusinessEntityID =Employee.BusinessEntityID
ORDER BY Bonus DESC;


/* 
Proposition 4:
return all employee's with lastname that begins with the letter "E" and list their first name last name and job title 
*/
USE AdventureWorks2017
SELECT P.LastName
    , P.FirstName
    ,E.JobTitle
FROM [Person].[Person] AS P
INNER JOIN [HumanResources].[Employee] AS E
    ON P.BusinessEntityID = E.BusinessEntityID
     AND LastName LIKE 'e%'
ORDER BY P.BusinessEntityID;


