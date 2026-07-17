
-- Consulta 1: JOIN simple
-- ver el detalle completo de cada venta 

SELECT 
    O.OrderID,
    O.OrderDate,
    C.CustomerName,
    P.ProductName,
    P.Category,
    OD.Quantity,
    OD.Sales,
    OD.Profit
FROM OrderDetails OD
JOIN Orders O ON OD.OrderID = O.OrderID
JOIN Customers C ON O.CustomerID = C.CustomerID
JOIN Products P ON OD.ProductID = P.ProductID
ORDER BY O.OrderDate DESC

-- Consulta 2: Agregación con GROUP BY
-- total de ventas, ganancia y unidades por subcategoría

SELECT 
    P.SubCategory,
    SUM(OD.Sales) 'Total de ventas',
    SUM(OD.Profit) 'Total de ganancia',
    SUM(OD.Quantity) 'Total de unidades'
FROM OrderDetails OD
JOIN Products P ON OD.ProductID = P.ProductID
GROUP BY P.SubCategory
ORDER BY 'Total de ventas' DESC


-- Consulta 3: TOP N
-- Objetivo: identificar los 5 productos con más unidades vendidas junto con el monto total generado por cada uno

SELECT TOP 5
    P.ProductName,
    SUM(OD.Quantity) 'Total de unidades',
    SUM(OD.Sales) 'Total de ventas'
FROM OrderDetails OD
JOIN Products P ON OD.ProductID = P.ProductID
GROUP BY P.ProductName
ORDER BY 'Total de unidades' DESC


-- Consulta 4: Subconsulta
-- Objetivo: identificar clientes cuyo total de compra supera el promedio general de compra por cliente

SELECT 
    C.CustomerName,
    SUM(OD.Sales) 'Total de compra'
FROM OrderDetails OD
JOIN Orders O ON OD.OrderID = O.OrderID
JOIN Customers C ON O.CustomerID = C.CustomerID
GROUP BY C.CustomerName
HAVING SUM(OD.Sales) > (
    SELECT AVG(TotalPorCliente)
    FROM (
        SELECT SUM(OD2.Sales) AS TotalPorCliente
        FROM OrderDetails OD2
        JOIN Orders O2 ON OD2.OrderID = O2.OrderID
        GROUP BY O2.CustomerID
    ) AS Promedios
)
ORDER BY 'Total de compra' DESC