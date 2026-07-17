
-- 1. Productos (eliminando duplicados por ProductID)

DELETE FROM Products;

WITH ProductosUnicos AS (
    SELECT 
        Product_ID, 
        Category, 
        Sub_Category, 
        Product_Name,
        ROW_NUMBER() OVER (PARTITION BY Product_ID ORDER BY Product_ID) AS rn
    FROM stores_sales_forecasting
)
INSERT INTO Products
SELECT Product_ID, Category, Sub_Category, Product_Name
FROM ProductosUnicos
WHERE rn = 1


-- 2. Clientes (eliminando duplicados por Customer_ID)

DELETE FROM Customers;

WITH ClientesUnicos AS (
    SELECT 
        Customer_ID, 
        Customer_Name, 
        Segment,
        ROW_NUMBER() OVER (PARTITION BY Customer_ID ORDER BY Customer_ID) AS rn
    FROM stores_sales_forecasting
)
INSERT INTO Customers
SELECT Customer_ID, Customer_Name, Segment
FROM ClientesUnicos
WHERE rn = 1

-- 3. Pedidos

DELETE FROM Orders;
WITH PedidosUnicos AS (
    SELECT 
        Order_ID, 
        Order_Date, 
        Ship_Date, 
        Ship_Mode, 
        Customer_ID, 
        Country, 
        City, 
        State, 
        Postal_Code, 
        Region,
        ROW_NUMBER() OVER (PARTITION BY Order_ID ORDER BY Order_ID) AS rn
    FROM stores_sales_forecasting
)
INSERT INTO Orders
SELECT 
    Order_ID, 
    TRY_CONVERT(DATE, Order_Date, 101), 
    TRY_CONVERT(DATE, Ship_Date, 101), 
    Ship_Mode, 
    Customer_ID, 
    Country, 
    City, 
    State, 
    Postal_Code, 
    Region
FROM PedidosUnicos
WHERE rn = 1

-- 4. Detalle de venta 

DELETE FROM OrderDetails;

INSERT INTO OrderDetails
SELECT 
    CAST(Row_ID AS INT),
    Order_ID,
    Product_ID,
    TRY_CAST(Sales AS DECIMAL(10,2)),
    TRY_CAST(Quantity AS INT),
    TRY_CAST(Discount AS DECIMAL(4,2)),
    TRY_CAST(Profit AS DECIMAL(10,2))
FROM stores_sales_forecasting