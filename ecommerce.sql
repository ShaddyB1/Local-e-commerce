CREATE DATABASE ecommerce;
USE ecommerce;

CREATE TABLE IF NOT EXISTS Users (
    UserID INT PRIMARY KEY AUTO_INCREMENT,
    Username VARCHAR(50) UNIQUE NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Password VARCHAR(255) NOT NULL,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS Products (
    ProductID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Description TEXT,
    Price DECIMAL(10, 2) NOT NULL,
    StockQuantity INT NOT NULL,
    CategoryID INT,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS Categories (
    CategoryID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(50) NOT NULL,
    Description TEXT
);

CREATE TABLE IF NOT EXISTS Orders (
    OrderID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT,
    OrderDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    TotalAmount DECIMAL(10, 2) NOT NULL,
    Status ENUM('Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled') DEFAULT 'Pending',
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

CREATE TABLE IF NOT EXISTS OrderItems (
    OrderItemID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT,
    ProductID INT,
    Quantity INT NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

ALTER TABLE Products
ADD FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID);

ALTER TABLE Products
ADD FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID);

INSERT INTO Categories (Name, Description) VALUES
('Electronics', 'Electronic devices and accessories'),
('Clothing', 'Apparel and fashion items'),
('Books', 'Physical and digital books');

INSERT INTO Products (Name, Description, Price, StockQuantity, CategoryID) VALUES
('Smartphone', 'Latest model smartphone', 699.99, 50, 1),
('Laptop', 'High-performance laptop', 1299.99, 30, 1),
('T-shirt', 'Cotton T-shirt', 19.99, 100, 2),
('Jeans', 'Denim jeans', 49.99, 75, 2),
('Python Programming', 'Learn Python programming', 29.99, 200, 3);

INSERT INTO Users (Username, Email, Password, FirstName, LastName) VALUES
('johndoe', 'john@example.com', 'hashedpassword123', 'John', 'Doe'),
('janedoe', 'jane@example.com', 'hashedpassword456', 'Jane', 'Doe');

INSERT INTO Orders (UserID, TotalAmount, Status) VALUES
(1, 719.98, 'Delivered'),
(2, 79.98, 'Processing');

INSERT INTO OrderItems (OrderID, ProductID, Quantity, Price) VALUES
(1, 1, 1, 699.99),
(1, 3, 1, 19.99),
(2, 4, 1, 49.99),
(2, 5, 1, 29.99);

CREATE VIEW vw_total_sales AS
SELECT 
    DATE(o.OrderDate) AS Date,
    SUM(o.TotalAmount) AS TotalSales,
    COUNT(DISTINCT o.OrderID) AS NumberOfOrders
FROM 
    Orders o
GROUP BY 
    DATE(o.OrderDate)
ORDER BY 
    Date DESC;
    
    CREATE VIEW vw_customer_segments AS
SELECT 
    u.UserID,
    u.Username,
    COUNT(DISTINCT o.OrderID) AS TotalOrders,
    SUM(o.TotalAmount) AS TotalSpent,
    CASE 
        WHEN COUNT(DISTINCT o.OrderID) > 10 AND SUM(o.TotalAmount) > 1000 THEN 'VIP'
        WHEN COUNT(DISTINCT o.OrderID) > 5 OR SUM(o.TotalAmount) > 500 THEN 'Regular'
        ELSE 'New'
    END AS CustomerSegment
FROM 
    Users u
LEFT JOIN 
    Orders o ON u.UserID = o.UserID
GROUP BY 
    u.UserID, u.Username;
    
    SET FOREIGN_KEY_CHECKS = 0;
    
    DELIMITER //
CREATE FUNCTION IF NOT EXISTS rand_string(n INT) 
RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
  DECLARE chars VARCHAR(62) DEFAULT 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  DECLARE result VARCHAR(255) DEFAULT '';
  DECLARE i INT DEFAULT 0;
  WHILE i < n DO
    SET result = CONCAT(result, SUBSTRING(chars, FLOOR(1 + RAND() * 62), 1));
    SET i = i + 1;
  END WHILE;
  RETURN result;
END //
DELIMITER ;


INSERT INTO Categories (Name, Description)
SELECT 
  CONCAT('Category ', rand_string(5)),
  CONCAT('Description for ', Name)
FROM 
  (SELECT rand_string(5) as Name FROM information_schema.tables LIMIT 20) as t
ON DUPLICATE KEY UPDATE Description = VALUES(Description);

INSERT INTO Products (Name, Description, Price, StockQuantity, CategoryID)
SELECT 
  CONCAT('Product ', rand_string(8)),
  CONCAT('Description for ', Name),
  ROUND(RAND() * 1000, 2),
  FLOOR(RAND() * 1000),
  (SELECT CategoryID FROM Categories ORDER BY RAND() LIMIT 1)
FROM 
  (SELECT rand_string(8) as Name FROM information_schema.tables LIMIT 1000) as t;


INSERT INTO Users (Username, Email, Password, FirstName, LastName)
SELECT 
  CONCAT('user', rand_string(5)),
  CONCAT(rand_string(7), '@example.com'),
  rand_string(12),
  rand_string(6),
  rand_string(8)
FROM 
  (SELECT rand_string(5) as Name FROM information_schema.tables LIMIT 500) as t
ON DUPLICATE KEY UPDATE Email = VALUES(Email);


INSERT INTO Orders (UserID, TotalAmount, Status)
SELECT 
  (SELECT UserID FROM Users ORDER BY RAND() LIMIT 1),
  ROUND(RAND() * 1000, 2),
  ELT(FLOOR(RAND() * 5) + 1, 'Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled')
FROM 
  (SELECT rand_string(5) as Name FROM information_schema.tables LIMIT 2000) as t;


INSERT INTO OrderItems (OrderID, ProductID, Quantity, Price)
SELECT 
  (SELECT OrderID FROM Orders ORDER BY RAND() LIMIT 1),
  (SELECT ProductID FROM Products ORDER BY RAND() LIMIT 1),
  FLOOR(RAND() * 5) + 1,
  ROUND(RAND() * 200, 2)
FROM 
  (SELECT rand_string(5) as Name FROM information_schema.tables LIMIT 5000) as t;


SET FOREIGN_KEY_CHECKS = 1;

SELECT 'Categories' as Table_Name, COUNT(*) as Row_Count FROM Categories
UNION ALL
SELECT 'Products' as Table_Name, COUNT(*) as Row_Count FROM Products
UNION ALL
SELECT 'Users' as Table_Name, COUNT(*) as Row_Count FROM Users
UNION ALL
SELECT 'Orders' as Table_Name, COUNT(*) as Row_Count FROM Orders
UNION ALL
SELECT 'OrderItems' as Table_Name, COUNT(*) as Row_Count FROM OrderItems;

SHOW FUNCTION STATUS WHERE Db = 'ecommerce' AND Name = 'rand_string';


  
  SHOW VARIABLES LIKE 'log_bin_trust_function_creators';
  
  SET GLOBAL log_bin_trust_function_creators = 0;
  
  CREATE INDEX idx_product_category ON Products(CategoryID);
  CREATE INDEX idx_order_user ON Orders(UserID);
  CREATE INDEX idx_orderitem_order ON OrderItems(OrderID);
  CREATE INDEX idx_orderitem_product ON OrderItems(ProductID);
  
  CREATE VIEW vw_sales_by_category AS
SELECT 
    c.Name AS CategoryName, 
    SUM(oi.Quantity * oi.Price) AS TotalSales
FROM 
    Categories c
    JOIN Products p ON c.CategoryID = p.CategoryID
    JOIN OrderItems oi ON p.ProductID = oi.ProductID
GROUP BY 
    c.CategoryID;

CREATE VIEW vw_customer_segmentation AS
SELECT 
    u.UserID,
    COUNT(DISTINCT o.OrderID) AS OrderCount,
    SUM(o.TotalAmount) AS TotalSpent,
    CASE 
        WHEN COUNT(DISTINCT o.OrderID) > 10 THEN 'High'
        WHEN COUNT(DISTINCT o.OrderID) > 5 THEN 'Medium'
        ELSE 'Low'
    END AS CustomerSegment
FROM 
    Users u
    LEFT JOIN Orders o ON u.UserID = o.UserID
GROUP BY 
    u.UserID;
  
  SELECT * FROM vw_customer_segmentation LIMIT 10;
  SELECT * FROM Users WHERE UserID = 10;
  SELECT * FROM Orders WHERE UserID = 10;
  
  INSERT INTO Orders (UserID, TotalAmount, Status)
VALUES 
(10, 150.00, 'Delivered'),
(10, 75.50, 'Processing');

INSERT INTO OrderItems (OrderID, ProductID, Quantity, Price)
SELECT 
    o.OrderID,
    (SELECT ProductID FROM Products ORDER BY RAND() LIMIT 1),
    FLOOR(RAND() * 5) + 1,
    ROUND(RAND() * 100, 2)
FROM Orders o
WHERE o.UserID = 10;
  
CREATE OR REPLACE VIEW vw_customer_segmentation AS
SELECT 
    u.UserID,
    COUNT(DISTINCT o.OrderID) AS OrderCount,
    COALESCE(SUM(o.TotalAmount), 0) AS TotalSpent,
    CASE 
        WHEN COUNT(DISTINCT o.OrderID) > 10 THEN 'High'
        WHEN COUNT(DISTINCT o.OrderID) > 5 THEN 'Medium'
        WHEN COUNT(DISTINCT o.OrderID) > 0 THEN 'Low'
        ELSE 'Inactive'
    END AS CustomerSegment
FROM 
    Users u
    LEFT JOIN Orders o ON u.UserID = o.UserID
GROUP BY 
    u.UserID;
    
    SELECT * FROM vw_customer_segmentation WHERE UserID = 10;

  
  
  

  

  
  
  
  
  
  
  

    
 
    
    
    
    
    







