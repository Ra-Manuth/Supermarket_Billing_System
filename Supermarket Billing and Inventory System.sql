CREATE DATABASE Supermarket_DB

ON PRIMARY
(
    NAME = N'Supermarket_DB',
    FILENAME = N'C:\SQL DATA\Supermarket_DB.mdf', 
    SIZE = 20MB,      
    MAXSIZE = 100MB,  
    FILEGROWTH = 5MB  
)
LOG ON
(
    NAME = N'Supermarket_DB_log',
    FILENAME = N'C:\SQL DATA\Supermarket_DB_log.ldf', 
    SIZE = 10MB,
    MAXSIZE = 50MB,
    FILEGROWTH = 5MB
)


 ====================================================
 1) Tables (8 tables)
 ====================================================
use Supermarket_DB;
1), Customers
CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    Phone NVARCHAR(20),
    Email NVARCHAR(100),
    Address NVARCHAR(255),
    CreatedAt DATETIME DEFAULT GETDATE()
);


2), Suppliers
CREATE TABLE Suppliers (
    SupplierID INT IDENTITY(1,1) PRIMARY KEY,
    SupplierName NVARCHAR(100) NOT NULL,
    ContactPhone NVARCHAR(20),
    ContactEmail NVARCHAR(100),
    Address NVARCHAR(255)
);

3), Employees
CREATE TABLE Employees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    Role NVARCHAR(50),
    Phone NVARCHAR(20),
    Email NVARCHAR(100),
    HiredDate DATE
);


4), Products
CREATE TABLE Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName NVARCHAR(150) NOT NULL,
    Category NVARCHAR(50),
    SupplierID INT NULL,
    Price DECIMAL(10,2) NOT NULL,
    StockQuantity INT NOT NULL CHECK (StockQuantity >= 0),
    ReorderLevel INT DEFAULT 5,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);


5), Sales (a sale header)
CREATE TABLE Sales (
    SaleID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NULL,
    EmployeeID INT NULL,
    SaleDate DATETIME DEFAULT GETDATE(),
    TotalAmount DECIMAL(12,2) DEFAULT 0,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);


6), SaleDetails (line items)
CREATE TABLE SaleDetails (
    SaleDetailID INT IDENTITY(1,1) PRIMARY KEY,
    SaleID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    Price DECIMAL(10,2) NOT NULL, -- price per unit at time of sale
    FOREIGN KEY (SaleID) REFERENCES Sales(SaleID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);


7), PurchaseOrders (restock orders from suppliers)
CREATE TABLE PurchaseOrders (
    PurchaseOrderID INT IDENTITY(1,1) PRIMARY KEY,
    SupplierID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    UnitCost DECIMAL(10,2) NOT NULL,
    OrderDate DATETIME DEFAULT GETDATE(),
    Received BIT DEFAULT 0,
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);


8), InventoryLog (records stock changes)
CREATE TABLE InventoryLog (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT NOT NULL,
    ChangeType NVARCHAR(50) NOT NULL, -- 'Sold', 'Restocked', 'Adjustment'
    QuantityChanged INT NOT NULL,
    ChangeDate DATETIME DEFAULT GETDATE(),
    ReferenceID INT NULL,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);


 ====================================================
 2) Sample data: at least 10 records per table
 ====================================================

 Customers (10)
INSERT INTO Customers (FullName, Phone, Email, Address)
VALUES
	('John Doe','0123456789','john@example.com','123 Main St'),
	('Jane Smith','0987654321','jane@example.com','456 Market Rd'),
	('Alice Wonderland','0123000001','alice@fantasy.com','10 Fantasy Rd'),
	('Bob Builder','0123000002','bob@build.com','99 Construction St'),
	('Cindy Liu','0123000003','cindy@shop.com','20 River Ave'),
	('David Kim','0123000004','david@home.com','33 Lake St'),
	('Eve Tran','0123000005','eve@online.com','77 Hill Rd'),
	('Frank Park','0123000006','frank@store.com','88 Garden Ln'),
	('Grace Lin','0123000007','grace@biz.com','5 Central Blvd'),
	('Henry Chou','0123000008','henry@market.com','9 Sunset St');


 Suppliers (10)
INSERT INTO Suppliers (SupplierName, ContactPhone, ContactEmail, Address) VALUES
('Fresh Farms','010111222','ff@fresh.com','Farm Road 1'),
('Ocean Foods','010111223','ocean@sea.com','Harbor St'),
('Bakery Supplies','010111224','bakery@sup.com','Baker Street'),
('Beverage Co','010111225','bev@drink.com','Beverage Plaza'),
('Green Fruits','010111226','green@fruit.com','Orchard Lane'),
('GrainCorp','010111227','grain@co.com','Grain Ave'),
('SnackMakers','010111228','snack@maker.com','Snack Blvd'),
('DairyBest','010111229','dairy@best.com','Dairy Road'),
('CandyLand','010111230','candy@land.com','Sweet St'),
('HouseholdGoods','010111231','house@goods.com','Home Ave');



 Employees (10)
INSERT INTO Employees (FullName, Role, Phone, Email, HiredDate)
VALUES
	('Sophea Meas','Cashier','011111001','sophea@shop.com','2023-01-05'),
	('Vuthy Long','Manager','011111002','vuthy@shop.com','2022-07-12'),
	('Rina Soth','Stock Clerk','011111003','rina@shop.com','2023-03-20'),
	('Chan Dara','Cashier','011111004','chan@shop.com','2024-02-01'),
	('Keo Samnang','Supervisor','011111005','keo@shop.com','2021-11-10'),
	('Srey Mom','Cleaner','011111006','srey@shop.com','2020-05-18'),
	('Somnang Heng','Delivery','011111007','somnang@shop.com','2022-09-09'),
	('Malis Sok','Cashier','011111008','malis@shop.com','2023-06-30'),
	('Piseth Narin','Accountant','011111009','piseth@shop.com','2019-12-01'),
	('Roth Sok','IT Support','011111010','roth@shop.com','2024-01-15');


 Products (10)
INSERT INTO Products (ProductName, Category, SupplierID, Price, StockQuantity, ReorderLevel)
VALUES
	('Milk 1L','Dairy',8,1.50,50,10),
	('Bread Loaf','Bakery',3,1.00,30,8),
	('Apple (1kg)','Fruit',5,2.50,100,20),
	('Rice 5kg','Grains',6,10.00,20,5),
	('Chocolate Bar','Snacks',7,2.50,100,15),
	('Orange Juice 1L','Beverages',4,3.00,50,10),
	('Banana (1kg)','Fruit',5,0.75,200,30),
	('Eggs 12pcs','Dairy',8,2.20,60,12),
	('Cooking Oil 1L','Grocery',6,5.00,40,10),
	('Toilet Paper (6)','Household',10,4.50,80,20);


 Sales (10) — linking to first 10 customers and employees
INSERT INTO Sales (CustomerID, EmployeeID, SaleDate, TotalAmount)
VALUES
	(1,1,'2025-08-01 09:15',3.50),
	(2,2,'2025-08-01 10:05',8.00),
	(3,1,'2025-08-02 11:20',5.25),
	(4,3,'2025-08-02 12:30',12.00),
	(5,4,'2025-08-03 13:40',6.50),
	(6,5,'2025-08-03 14:50',9.75),
	(7,6,'2025-08-04 15:55',4.00),
	(8,7,'2025-08-04 16:10',7.30),
	(9,8,'2025-08-05 17:20',11.60),
	(10,9,'2025-08-05 18:00',2.50);


 SaleDetails (10) — one or two items per sale; price repeats product price for simplicity
INSERT INTO SaleDetails (SaleID, ProductID, Quantity, Price)
VALUES
	(1,1,2,1.50),   -- Sale 1: 2 Milk
	(2,5,3,2.50),   -- Sale 2: 3 Chocolate Bars
	(3,4,1,10.00),  -- Sale 3: 1 Rice 5kg
	(4,6,4,3.00),   -- Sale 4: 4 Orange Juice
	(5,2,2,1.00),   -- Sale 5: 2 Bread
	(6,7,5,0.75),   -- Sale 6: 5 Bananas
	(7,8,2,2.20),   -- Sale 7: 2 Eggs pack
	(8,9,1,5.00),   -- Sale 8: 1 Cooking Oil
	(9,10,2,4.50),  -- Sale 9: 2 Toilet Paper
	(10,3,1,2.50);  -- Sale 10: 1 Apple

 PurchaseOrders (10) — restock flow (some received, some not)
INSERT INTO PurchaseOrders (SupplierID, ProductID, Quantity, UnitCost, OrderDate, Received)
VALUES
	(8,1,20,1.10,'2025-07-28',1),
	(3,2,50,0.70,'2025-07-29',1),
	(5,3,100,1.40,'2025-07-30',1),
	(6,4,30,8.00,'2025-08-01',1),
	(7,5,200,1.50,'2025-08-02',0),
	(4,6,60,2.20,'2025-08-02',1),
	(5,7,150,0.40,'2025-07-25',1),
	(8,8,80,1.80,'2025-08-03',0),
	(6,9,40,4.00,'2025-08-03',0),
	(10,10,120,3.00,'2025-08-04',1);


 InventoryLog (10) — initial logs to match some orders/sales
INSERT INTO InventoryLog (ProductID, ChangeType, QuantityChanged, ChangeDate, ReferenceID)
VALUES
	(1,'Initial Stock',50,'2025-07-01',NULL),
	(2,'Initial Stock',30,'2025-07-01',NULL),
	(3,'Initial Stock',100,'2025-07-01',NULL),
	(4,'Initial Stock',20,'2025-07-01',NULL),
	(5,'Initial Stock',100,'2025-07-01',NULL),
	(6,'Initial Stock',50,'2025-07-01',NULL),
	(7,'Initial Stock',200,'2025-07-01',NULL),
	(8,'Initial Stock',60,'2025-07-01',NULL),
	(9,'Initial Stock',40,'2025-07-01',NULL),
	(10,'Initial Stock',80,'2025-07-01',NULL);


 select * from SaleDetails;
  select * from Products;
  select * from InventoryLog;
  select * from Sales;
    select * from PurchaseOrders;

--	DELETE FROM Sales
--WHERE SaleID IN (17);


 ====================================================
 3) Views (3 views)
    - vw_CustomerSalesSummary
    - vw_ProductStockStatus
    - vw_SalesDetailSummary
 ====================================================



CREATE VIEW vw_CustomerSalesSummary AS
SELECT 
    c.CustomerID,
    c.FullName,
    COUNT(s.SaleID) AS NumberOfSales,
    ISNULL(SUM(s.TotalAmount), 0) AS TotalSpent
FROM Customers as c
LEFT JOIN Sales as s ON c.CustomerID = s.CustomerID
GROUP BY c.CustomerID, c.FullName;
GO


CREATE VIEW vw_ProductStockStatus AS
SELECT 
    p.ProductID,
    p.ProductName,
    p.Category,
    p.StockQuantity,
    p.ReorderLevel,
    ISNULL(SUM(sd.Quantity), 0) AS TotalUnitsSold
FROM Products p
LEFT JOIN SaleDetails as sd ON p.ProductID = sd.ProductID
GROUP BY p.ProductID, p.ProductName, p.Category, p.StockQuantity, p.ReorderLevel;
GO



CREATE VIEW vw_SalesDetailSummary AS
SELECT 
    s.SaleID,
    s.SaleDate,
    ISNULL(c.CustomerID,0) AS CustomerID,
    c.FullName AS CustomerName,
    sd.SaleDetailID,
    sd.ProductID,
    p.ProductName,
    sd.Quantity,
    sd.Price,
    (sd.Quantity * sd.Price) AS LineTotal
FROM Sales s
LEFT JOIN Customers as c ON s.CustomerID = c.CustomerID
INNER JOIN SaleDetails as sd ON s.SaleID = sd.SaleID
INNER JOIN Products as p ON sd.ProductID = p.ProductID;
GO



 Views test (simple selects)
SELECT * FROM vw_CustomerSalesSummary;
SELECT * FROM vw_ProductStockStatus;
SELECT * FROM vw_SalesDetailSummary;

 ====================================================
 4) Triggers (2 triggers) — why they are added explained below
    - trg_UpdateStock_AfterSale: reduces stock & logs when a sale detail is inserted
    - trg_UpdateStock_AfterPurchase: increases stock & logs when a purchase order is marked/inserted
 Note: These triggers do not use explicit transactions or commit/rollback.
 ====================================================

 Trigger: after inserting sale details, reduce product stock and add inventory log
CREATE TRIGGER trg_UpdateStock_AfterSale
ON SaleDetails
AFTER INSERT
AS
BEGIN
    -- Reduce stock for each inserted sale detail
    UPDATE p
    SET p.StockQuantity = p.StockQuantity - i.Quantity
    FROM Products p
    INNER JOIN inserted i ON p.ProductID = i.ProductID;

    -- Insert inventory log entries
    INSERT INTO InventoryLog (ProductID, ChangeType, QuantityChanged, ReferenceID)
    SELECT i.ProductID, 'Sold', i.Quantity, i.SaleID
    FROM inserted i;
END;
GO

--Example For Demo

--INSERT INTO Sales (CustomerID, EmployeeID, TotalAmount)
--VALUES (1, 1, 125.00);  -- CustomerID=1, EmployeeID=1, TotalAmount = 50 * 2.50 (Apple price)

--DECLARE @NewSaleID INT;
--SET @NewSaleID = SCOPE_IDENTITY();
--INSERT INTO SaleDetails (SaleID, ProductID, Quantity, Price)
--VALUES (@NewSaleID, 3, 50, 2.50);  -- ProductID=3 is Apple (1kg), Quantity=50, Price=2.50

--UPDATE Products
--SET StockQuantity = 100
--WHERE ProductID = 3;  -- ProductID 3 = Apple (1kg)

--DELETE FROM SaleDetails
--WHERE ProductID = 3;
--DELETE FROM InventoryLog
--WHERE ProductID = 3 AND ChangeType = 'Sold';





 Trigger: after inserting purchase orders (assume items received when row inserted),
 increase stock and add inventory log when Received = 1.

CREATE TRIGGER trg_UpdateStock_AfterPurchase
ON PurchaseOrders
AFTER INSERT
AS
BEGIN
    -- Increase stock for orders inserted with Received = 1
    UPDATE p
    SET p.StockQuantity = p.StockQuantity + i.Quantity
    FROM Products p
    INNER JOIN inserted i ON p.ProductID = i.ProductID
    WHERE i.Received = 1;

    -- Log the restock for entries where Received = 1
    INSERT INTO InventoryLog (ProductID, ChangeType, QuantityChanged, ReferenceID)
    SELECT i.ProductID, 'Restocked', i.Quantity, i.PurchaseOrderID
    FROM inserted i
    WHERE i.Received = 1;
END;
GO
--Example For Demo

--INSERT INTO PurchaseOrders (SupplierID, ProductID, Quantity, UnitCost, OrderDate, Received)
--VALUES 
--(3, 2, 50, 0.70, GETDATE(), 1);  -- SupplierID=3, ProductID=2 (Bread Loaf), Quantity=50


--DELETE FROM InventoryLog
--WHERE ReferenceID = 12
--  AND ProductID = 2
--  AND ChangeType = 'Restocked';

--  UPDATE Products
--SET StockQuantity = StockQuantity - 50
--WHERE ProductID = 2;

---- 4️⃣ Delete the demo PurchaseOrder
--DELETE FROM PurchaseOrders
--WHERE PurchaseOrderID = 12;


 ====================================================
 5) Stored Procedures (3)
    - sp_AddSale: insert sale header & details (trigger will update stock)
    - sp_RestockProduct: create purchase order (and mark Received optionally)
    - sp_GetProductSalesReport: returns aggregated sales info for a product
 Note: SPs avoid explicit transactions/commits as requested.
 ====================================================

 5.1 AddSale: Adds a sale header and multiple sale details using a temp table input pattern.
    Usage example included in comments after creation.
CREATE PROCEDURE sp_AddSale
    @CustomerID INT = NULL,
    @EmployeeID INT = NULL,
    @TotalAmount DECIMAL(12,2) = 0
AS
BEGIN
    INSERT INTO Sales (CustomerID, EmployeeID, SaleDate, TotalAmount)
    VALUES (@CustomerID, @EmployeeID, GETDATE(), @TotalAmount);

    SELECT SCOPE_IDENTITY() AS NewSaleID;
END;
GO

 5.2 RestockProduct: create a purchase order record. If @MarkReceived = 1, it sets Received = 1.
CREATE PROCEDURE sp_RestockProduct
    @SupplierID INT,
    @ProductID INT,
    @Quantity INT,
    @UnitCost DECIMAL(10,2),
    @MarkReceived BIT = 0
AS
BEGIN
    INSERT INTO PurchaseOrders (SupplierID, ProductID, Quantity, UnitCost, OrderDate, Received)
    VALUES (@SupplierID, @ProductID, @Quantity, @UnitCost, GETDATE(), @MarkReceived);

    SELECT SCOPE_IDENTITY() AS NewPurchaseOrderID;
END;
GO

 5.3 GetProductSalesReport: aggregated totals for a product

CREATE PROCEDURE sp_GetProductSalesReport
@ProductID INT
AS
	BEGIN
		SELECT
			p.ProductID,
			p.ProductName,
			p.Category,
			p.StockQuantity,
			p.ReorderLevel,
			ISNULL(SUM(sd.Quantity),0) AS TotalUnitsSold,
			ISNULL(SUM(sd.Quantity * sd.Price),0) AS TotalRevenue
		FROM Products p
		LEFT JOIN SaleDetails sd ON p.ProductID = sd.ProductID
		WHERE p.ProductID = @ProductID
		GROUP BY p.ProductID, p.ProductName, p.Category, p.StockQuantity, p.ReorderLevel;
	END;
GO

--EXEC sp_GetProductSalesReport 
--     @ProductID = 2, 
--     @StartDate = '2025-08-01', 
--     @EndDate = '2025-08-14';






use master;
go

--Full Backup
backup database Supermarket_DB
TO DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\Backup\SupermarketDB.bak';
GO

--Differential backup
backup database Supermarket_DB
to disk = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\Backup\SupermarketDB.bak'
with differential;

--Drop Database
alter database [Supermarket_DB] set single_user with rollback immediate;
drop database [Supermarket_DB];

--Recovery
restore database Supermarket_DB
from disk = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\Backup\SupermarketDB.bak'
with
move 'Supermarket_DB' to 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\SupermarketDB.mdf',
move 'Supermarket_DB_log' to 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\SupermarketDBlog.ldf',
norecovery,
stats =10;

RESTORE DATABASE Supermarket_DB
WITH RECOVERY;




 ====================================================
 6) Example usage notes & small tests
 ====================================================

Example: Use sp_AddSale to create a sale header, then insert details and let the trigger reduce stock
EXEC sp_AddSale @CustomerID = 1, @EmployeeID = 1, @TotalAmount = 3.5;
-- Capture the returned NewSaleID from the result, then insert SaleDetails:
-- Suppose NewSaleID = 11 (check SCOPE_IDENTITY result); for demo here we insert directly:
INSERT INTO Sales (CustomerID, EmployeeID, TotalAmount)
  VALUES (1,1,3.50);
DECLARE @DemoSaleID INT = SCOPE_IDENTITY();
INSERT INTO SaleDetails (SaleID, ProductID, Quantity, Price)
VALUES 
  (5, 1, 2, 1.50); -- Trigger will reduce stock and add InventoryLog

-- Example: Create a purchase order and mark as received (this will cause trigger to update stock)
EXEC sp_RestockProduct @SupplierID = 8, @ProductID = 1, @Quantity = 20, @UnitCost = 1.10, @MarkReceived = 1;

-- Example: Get product sales report
EXEC sp_GetProductSalesReport @ProductID = 1;

 Create login & user * Role with Grand Permission.
CREATE ROLE Seller_Roless;
CREATE LOGIN seller_one WITH PASSWORD = 'Seller@123',
check_policy = on;
CREATE USER seller_one FOR LOGIN seller_one;
GRANT SELECT, INSERT, UPDATE ON Sales TO seller_one;
ALTER ROLE Seller_Roless ADD MEMBER seller_one;

 Grant permissions
GRANT SELECT, INSERT, UPDATE ON Sales TO Seller_Roless;
GRANT SELECT, INSERT ON SaleDetails TO Seller_Roless;

 Script end
