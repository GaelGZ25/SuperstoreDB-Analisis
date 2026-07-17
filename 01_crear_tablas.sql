CREATE DATABASE SuperstoreDB
GO

USE SuperstoreDB
GO

-- 1. Clientes
CREATE TABLE Customers (
    CustomerID VARCHAR(10) NOT NULL,
    CustomerName VARCHAR(100) NOT NULL,
    Segment VARCHAR(50) NULL,
    CONSTRAINT pk_CustomerID PRIMARY KEY (CustomerID)
);

-- 2. Productos
CREATE TABLE Products (
    ProductID VARCHAR(20) NOT NULL,
    Category VARCHAR(50) NOT NULL,
    SubCategory VARCHAR(50) NOT NULL,
    ProductName VARCHAR(200) NOT NULL,
    CONSTRAINT pk_ProductID PRIMARY KEY (ProductID)
);

-- 3. Pedidos
CREATE TABLE Orders (
    OrderID VARCHAR(20) NOT NULL,
    CustomerID VARCHAR(10) NOT NULL,
    OrderDate DATE NOT NULL,
    ShipDate DATE NULL,
    ShipMode VARCHAR(50) NULL,
    Country VARCHAR(50) NOT NULL,
    City VARCHAR(50) NOT NULL,
    State VARCHAR(50) NULL,
    PostalCode VARCHAR(10) NOT NULL,
    Region VARCHAR(50) NOT NULL,
    CONSTRAINT pk_OrderID PRIMARY KEY (OrderID),
    CONSTRAINT fk_Orders_Customers FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- 4. Detalle de venta
CREATE TABLE OrderDetails (
    RowID INT NOT NULL,
    OrderID VARCHAR(20) NOT NULL,
    ProductID VARCHAR(20) NOT NULL,
    Sales DECIMAL(10,2) NOT NULL,
    Quantity INT NOT NULL,
    Discount DECIMAL(4,2) NULL,
    Profit DECIMAL(10,2) NULL,
    CONSTRAINT pk_RowID PRIMARY KEY (RowID),
    CONSTRAINT fk_OrderDetails_Orders FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    CONSTRAINT fk_OrderDetails_Products FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);