



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
 , Subcategory.EnglishProductSubcategoryName  
For JSON PATH
,Root('Return all product that has productcategorykey at most 2 ')
,INCLUDE_NULL_VALUES


