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