
/*
Proposition 1:
Find all product that has productcategorykey at most 2 and return the product key, englishcategoryname and englishsubcategoryname
use table from [dbo].[DimProductSubcategory] and [dbo].[DimProductCategory], and use AdventureWorkDW2017 for query
*/
USE AdventureWorksDW2017
SELECT Category.ProductCategoryKey
, Category.EnglishProductCategoryName
, Subcategory.EnglishProductSubcategoryName
FROM [dbo].[DimProductCategory] as Category
    INNER JOIN [dbo].[DimProductSubcategory] as SubCategory
        ON Category.ProductCategoryKey = SubCategory.ProductCategoryKey
WHERE Category.ProductCategoryKey <= 2
 GROUP BY  Category.ProductCategoryKey
 , Category.EnglishProductCategoryName
 , Subcategory.EnglishProductSubcategoryName;      


/*
Proposition 2:
Find all customer name from France  return  the customer full name(first and last) and location (region and city they are in)
use [dbo].[DimCustomer] and [dbo].[DimGeography] 
*/
USE AdventureWorksDW2017
SELECT (Cust.FirstName + N' '+ Cust.LastName) AS FUllname
, (GEO.City + N', ' + GEO.EnglishCountryRegionName) AS Location
FROM [dbo].[DimGeography] as GEO
    INNER JOIN [dbo].[DimCustomer] as Cust
        ON GEO.GeographyKey = Cust.GeographyKey
WHERE GEO.CountryRegionCode = N'FR'
GROUP BY(Cust.FirstName + N' '+ Cust.LastName), (GEO.City + N', ' + GEO.EnglishCountryRegionName)

/*
Proposition 3: find the total cost and number productline where orderdate from January 2012 to May 2012
return all orderdate, product line, numproduct as number of productline,  and sum of totalcost
use AdventureWorksDW2017
*/
SELECT Sales.OrderDate
, Reseller.ProductLine
, count(Reseller.ProductLine) AS numProduct
, sum(Sales.TotalProductCost) AS SumofTotalCost
FROM [dbo].[DimReseller] AS Reseller
    INNER JOIN [dbo].[FactResellerSales] AS Sales
        ON Reseller.ResellerKey = Sales.ResellerKey
WHERE Sales.OrderDate > '20120101' and Sales.OrderDate < '20120501'
GROUP BY Reseller.ProductLine, OrderDate ;      
