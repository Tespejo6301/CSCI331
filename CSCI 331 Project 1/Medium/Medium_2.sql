/*
Proposition 4:
Find all employees who's bonus are lower than $1000 return employee key, first and last name and order the table by the bonus amount
use [Person].[Person] and [Sales].[SalesPerson] for table and use Adventure Works2017
*/
USE AdventureWorks2017
SELECT SP.BusinessEntityID
, P.FirstName
, P.LastName
, SP.Bonus
FROM [Sales].[SalesPerson] as SP
    INNER JOIN [Person].[Person] as P
        ON SP.BusinessEntityID = P.BusinessEntityID
        AND SP.Bonus < 1000
GROUP BY SP.BusinessEntityID
, P.FirstName
, P.LastName
, SP.Bonus       
ORDER BY SP.Bonus;
/*
Proposition 5:
Find the number of quota and sum quota of each employee return the employee id, firstname,
 lastname , number quota and total quota
 use [Person].[Person] and [Sales].[SalesPersonQuotaHistory] for table and use Adventure Works2017
*/
USE AdventureWorks2017
SELECT P.BusinessEntityID
, P.FirstName,P.LastName
,  Count(Q.BusinessEntityID) AS NumQuota
, SUM(Q.SalesQuota) AS totalQuota
FROM [Sales].[SalesPersonQuotaHistory] as Q
    INNER JOIN [Person].[Person] as P
        ON P.BusinessEntityID = Q.BusinessEntityID
GROUP BY P.BusinessEntityID, P.FirstName, P.LastName;

