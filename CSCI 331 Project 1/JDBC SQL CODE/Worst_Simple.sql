--Return all Products that have been scrapped
SELECT p.Name AS ProductName
FROM Production.ScrapReason AS s
    INNER JOIN Production.Product AS p
        ON p.ProductID = s.ScrapReasonID;