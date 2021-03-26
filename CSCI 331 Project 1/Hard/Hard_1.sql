/*
Proposition 1:
Find the max order which returns the lastname and firstname of the employee who handle the product and other cost is not 0,
the product alternative name, total product cost, standard cost and other cost (other cost that contribute to total product cost)
use the table [dbo].[FactResellerSales], dbo].[DimProduct], [dbo].[DimEmployee] and use query AdventureWorksDW2017
*/
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
DECLARE @maxdate AS INT = (SELECT MIN(OrderDateKey)
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
            AND Reseller.OrderDateKey = @maxdate
WHERE   (Reseller.TotalProductCost - Reseller.ProductStandardCost) > 0   
GROUP BY Product.ProductAlternateKey
    , Employee.LastName
    , Employee.FirstName
   

/*
Proposition 2:
Find all customer who picked clothes as in the survey and what kind of article of clothing they pick
return the gender, how many people in particular gender pick the article of clothing  and the article of clothing they picked and sumarrization of how many people
 in a particular gender pick that style of clothing.
*/
USE AdventureWorksDW2017
DROP FUNCTION IF EXISTS [dbo].[Description]
GO
CREATE Function Description
(
    @GenderInitial NVARCHAR(100),
    @Subcategory NVARCHAR(100),
    @numpeople NVARCHAR(100)
) 
RETURNS NVARCHAR(100)
AS 
Begin
        DECLARE @statement NVARCHAR(100)
        DECLARE @gender NVARCHAR(12)
        Select @gender = Case
        When @gender = 'm' then 'Male'
        ELSE
        'Female'
        End
        SET @statement = CONCAT('There are ', @numpeople, ' ', @gender, ' who pick ', @Subcategory)
        Return (@statement)
END
Go        
SELECT  Customer.Gender
, count(Customer.Gender) As numpeople
, ClothCateg.EnglishProductSubcategoryName
, [dbo].[Description](Gender, ClothCateg.EnglishProductSubcategoryName, count(Customer.Gender))AS Summary

FROM [dbo].[FactSurveyResponse] AS Survey
 INNER JOIN [dbo].[DimCustomer] AS Customer
    ON Customer.CustomerKey = Survey.CustomerKey
 INNER JOIN [dbo].[DimProductSubcategory] AS ClothCateg
    ON Survey.ProductSubCategoryKey = ClothCateg.ProductSubCategoryKey
    AND Survey.EnglishProductCategoryName = 'Clothing'
GROUP BY Customer.Gender, ClothCateg.EnglishProductSubcategoryName


/*
Proposition 3:
Find the resellers that have their orders in year 2011 and came from Canada
return business type, number of business in the area where order date is in 2011 
and description which calls the scalar function to produce the statement 
“The (business type) is located in (province name) , Cananda”
 ordered by the province code in alphabetical order
use [dbo].[DimGeography],[dbo].[DimReseller] and dbo].[FactResellerSales] for tables 
and use AdventureWorksDW2017 as query
*/
DROP FUNCTION IF EXISTS [dbo].[Location]
GO
CREATE Function Location
(
    @ProvinceCode NVARCHAR(100),
    @BusinessType NVARCHAR(100)

) 
RETURNS NVARCHAR(100)
AS 
Begin
        DECLARE @Summary NVARCHAR(100)
        SET @Summary = CONCAT(N'The ', @BusinessType, N' is located in ', @ProvinceCode, N', Canada')
        Return (@Summary)
END
Go        
USE AdventureWorksDW2017
SELECT Reseller.BusinessType
, count (Reseller.BusinessType)  as numBusiness
,[dbo].[Location] (Geo.StateProvinceName, Reseller.BusinessType) AS Description

FROM [dbo].[DimGeography] AS Geo
    INNER JOIN [dbo].[DimReseller] AS Reseller
        ON Geo.GeographyKey = Reseller.GeographyKey
        AND Geo.CountryRegionCode = N'CA'
    INNER JOIN [dbo].[FactResellerSales] AS FactResell    
        ON Reseller.ResellerKey = FactResell.ResellerKey
WHERE FactResell.OrderDateKey >= '20110101' AND FactResell.OrderDateKey < '20120101' 
GROUP BY Geo.StateProvinceName
, Reseller.BusinessType 
ORDER BY Reseller.BusinessType ;