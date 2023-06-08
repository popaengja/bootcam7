-- สร้างฐานข้อมูล "restaurant.db"
.open restaurant.db

-- ลบตารางที่มีอยู่แล้ว (ถ้ามี)
DROP TABLE IF EXISTS Menu;
DROP TABLE IF EXISTS Drinks_Beverages;
DROP TABLE IF EXISTS Staff;
DROP TABLE IF EXISTS member;
DROP TABLE IF EXISTS invoices;

-- สร้างตาราง "Menu"
CREATE TABLE Menu (
  menu_id INT PRIMARY KEY,
  menu_name TEXT,
  menu_price INT NOT NULL
);
INSERT INTO Menu VALUES
  (0, 'Peking Duck', 799),
  (1, 'Kung Pao Chicken', 180),
  (2, 'Sweet and Sour Pork', 200),
  (3, 'Hot Pot', 400),
  (4, 'Dim Sum', 290);

-- สร้างตาราง "Drinks_Beverages"
CREATE TABLE Drinks_Beverages (
  menu_id INT PRIMARY KEY,
  menu_name TEXT,
  menu_price INT NOT NULL
);
INSERT INTO Drinks_Beverages VALUES
  (0, 'Orange Juice', 70),
  (1, 'Lemonade', 70),
  (2, 'Apple Juice', 70),
  (3, 'Grape Juice', 70),
  (4, 'Tomato Juice', 70);

-- สร้างตาราง "staff"
CREATE TABLE Staff (
  staffId INT PRIMARY KEY,
  staffName TEXT
);
INSERT INTO Staff VALUES
  (1, 'Mana'),
  (2, 'Manee'),
  (3, 'Piti'),
  (4, 'Shujai');

-- สร้างตาราง "member"
CREATE TABLE Member (
  memberId INT PRIMARY KEY,
  memberName TEXT,
  gender TEXT,
  invoicesId INT,
  FOREIGN KEY (invoicesId) REFERENCES invoices(invoicesId)
);
INSERT INTO Member VALUES
  (1, 'Sam', 'Mr.', 1),
  (2, 'Ann', 'Mrs.', 2),
  (3, 'Adam', 'Mr.', 3),
  (4, 'Cindy', 'Miss', 4),
  (5, 'Peter', 'Mr.', 5);

-- สร้างตาราง "invoices"
CREATE TABLE Invoices (
  invoicesId INT PRIMARY KEY,
  invoiceNumber VARCHAR(50),
  invoiceDate DATE,
  totalAmount DECIMAL(10,2),
  customerId INT
);
INSERT INTO Invoices VALUES
  (1, 'INV001', '2023-05-01', 1000.00, 100),
  (2, 'INV002', '2023-05-02', 2500.00, 200),
  (3, 'INV003', '2023-05-03', 1500.50, 150),
  (4, 'INV004', '2023-05-04', 1800.75, 300),
  (5, 'INV005', '2023-05-05', 500.25, 250);
-- QUERY FROM 4 TABLES
select * from Menu;  
select * from Drinks_Beverages;  
select * from Staff;  
select * from Member; 
select * from Invoices; 

-- top  5 sale - -
SELECT m.menu_name, COUNT(*) AS total_sales
FROM Menu m
JOIN (
  SELECT mb.invoicesId
  FROM Member mb
  JOIN Invoices i ON mb.invoicesId = i.invoicesId
) AS subquery
ON m.menu_id = subquery.invoicesId
GROUP BY m.menu_id, m.menu_name
ORDER BY total_sales DESC
LIMIT 5;
-- top employee --
WITH sales_data AS (
  SELECT i.customerId, SUM(i.totalAmount) AS net_price
  FROM Invoices i
  GROUP BY i.customerId
)
SELECT s.staffName, s.staffId, sd.net_price
FROM Staff s
JOIN sales_data sd ON s.staffId = sd.customerId
WHERE sd.net_price = (
  SELECT MAX(net_price)
  FROM sales_data
);
 --  sales vs member --
WITH membership_sales AS (
  SELECT m.memberId, m.memberName, COUNT(i.invoicesId) AS total_sales
  FROM Member m
  LEFT JOIN Invoices i ON m.memberId = i.customerId
  GROUP BY m.memberId, m.memberName
), total_memberships AS (
  SELECT COUNT(*) AS total_members
  FROM Member
)
SELECT ms.memberName, ms.total_sales, tm.total_members
FROM membership_sales ms
CROSS JOIN total_memberships tm;











