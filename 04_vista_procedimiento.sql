
--Resumen de ventas por subcategoría
-- Objetivo: evitar reescribir el JOIN + GROUP BY cada vez que se necesite este reporte; se consulta como una tabla normal

CREATE VIEW VentasSubCategoria 
AS 
SELECT P.SubCategory,
SUM (OD.Sales) 'Total de ventas',
SUM (OD.Profit) 'Total de ganancia',
SUM (OD.Quantity) 'Total de unidades'
FROM OrderDetails OD
JOIN Products P ON OD.ProductID = P.ProductID
GROUP BY P.SubCategory

SELECT * FROM VentasSubCategoria

--Procedimiento almacenado
-- Objetivo: obtener el desglose de ventas por producto, filtrado a una subcategoría específica que se pasa como parámetro

CREATE PROC sp_ventasSubCategoria 
@SubCat VARCHAR (50)
AS
BEGIN
SELECT P.ProductID, P.ProductName, P.SubCategory, 
SUM(OD.Sales) 'Total de ventas',
SUM (OD.Quantity) 'Total de unidades',
SUM (OD.Profit) 'Ganancia'
FROM OrderDetails OD 
JOIN Products P ON OD.ProductID = P.ProductID
WHERE P.SubCategory = @SubCat
GROUP BY P.ProductID, P.ProductName, P.SubCategory
END

EXEC sp_ventasSubCategoria 'Tables'