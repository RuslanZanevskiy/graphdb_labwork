-- ==============================================================================
-- Script       : ClothingStoreGraphDB.sql
-- Description  : Graph database for clothing store: collections, brands, sizes
-- DBMS         : Microsoft SQL Server 2019
-- ==============================================================================

IF DB_ID('ClothingStoreGraph') IS NULL
    CREATE DATABASE ClothingStoreGraph;
GO

USE ClothingStoreGraph;
GO

ALTER DATABASE ClothingStoreGraph SET COMPATIBILITY_LEVEL = 150;
GO

-- 1. Create Node Tables
-- ==============================================================================

DROP TABLE IF EXISTS dbo.Made_Of;
DROP TABLE IF EXISTS dbo.Belongs_To;
DROP TABLE IF EXISTS dbo.Has_Size;
DROP TABLE IF EXISTS dbo.Includes;
DROP TABLE IF EXISTS dbo.Produces;
GO

DROP TABLE IF EXISTS dbo.Material;
DROP TABLE IF EXISTS dbo.Category;
DROP TABLE IF EXISTS dbo.Size;
DROP TABLE IF EXISTS dbo.Product;
DROP TABLE IF EXISTS dbo.Collection;
DROP TABLE IF EXISTS dbo.Brand;
GO

CREATE TABLE dbo.Brand
(
    BrandID       INT              NOT NULL,
    Name          NVARCHAR(100)    NOT NULL,
    Country       NVARCHAR(100)    NULL,
    FoundedYear   INT              NULL,
    CONSTRAINT PK_Brand PRIMARY KEY (BrandID)
) AS NODE;
GO

CREATE TABLE dbo.Collection
(
    CollectionID  INT              NOT NULL,
    Name          NVARCHAR(100)    NOT NULL,
    Season        NVARCHAR(20)     NULL,
    Year          INT              NULL,
    CONSTRAINT PK_Collection PRIMARY KEY (CollectionID)
) AS NODE;
GO

CREATE TABLE dbo.Product
(
    ProductID     INT              NOT NULL,
    Name          NVARCHAR(200)    NOT NULL,
    Price         DECIMAL(10,2)    NULL,
    Color         NVARCHAR(50)     NULL,
    CONSTRAINT PK_Product PRIMARY KEY (ProductID)
) AS NODE;
GO

CREATE TABLE dbo.Size
(
    SizeID        INT              NOT NULL,
    Name          NVARCHAR(20)     NOT NULL,
    SizeType      NVARCHAR(50)     NULL,
    CONSTRAINT PK_Size PRIMARY KEY (SizeID)
) AS NODE;
GO

CREATE TABLE dbo.Category
(
    CategoryID    INT              NOT NULL,
    Name          NVARCHAR(100)    NOT NULL,
    CONSTRAINT PK_Category PRIMARY KEY (CategoryID)
) AS NODE;
GO

CREATE TABLE dbo.Material
(
    MaterialID    INT              NOT NULL,
    Name          NVARCHAR(100)    NOT NULL,
    CONSTRAINT PK_Material PRIMARY KEY (MaterialID)
) AS NODE;
GO

-- ==============================================================================
-- 2. Create Edge Tables with Connection Constraints
-- ==============================================================================

CREATE TABLE dbo.Produces
(
    DateProduced   DATE             NULL,
    CONSTRAINT EC_Produces CONNECTION (dbo.Brand TO dbo.Product)
) AS EDGE;
GO

CREATE TABLE dbo.Includes
(
    DateAdded      DATE             NULL,
    CONSTRAINT EC_Includes CONNECTION (dbo.Collection TO dbo.Product)
) AS EDGE;
GO

CREATE TABLE dbo.Has_Size
(
    StockQuantity  INT              NULL,
    CONSTRAINT EC_Has_Size CONNECTION (dbo.Product TO dbo.Size)
) AS EDGE;
GO

CREATE TABLE dbo.Belongs_To
(
    AssignedDate   DATE             NULL,
    CONSTRAINT EC_Belongs_To CONNECTION (dbo.Product TO dbo.Category)
) AS EDGE;
GO

CREATE TABLE dbo.Made_Of
(
    Percentage     DECIMAL(5,2)     NULL,
    CONSTRAINT EC_Made_Of CONNECTION (dbo.Product TO dbo.Material)
) AS EDGE;
GO

-- ==============================================================================
-- 3. Populate Node Tables (10+ rows each)
-- ==============================================================================

INSERT INTO dbo.Brand (BrandID, Name, Country, FoundedYear) VALUES
(1,  N'Nike',           N'USA',       1964),
(2,  N'Adidas',         N'Germany',   1949),
(3,  N'Puma',           N'Germany',   1948),
(4,  N'Zara',           N'Spain',     1975),
(5,  N'H&M',            N'Sweden',    1947),
(6,  N'Levi''s',        N'USA',       1853),
(7,  N'Gucci',          N'Italy',     1921),
(8,  N'Louis Vuitton',  N'France',    1854),
(9,  N'Uniqlo',         N'Japan',     1949),
(10, N'Gap',            N'USA',       1969),
(11, N'Tommy Hilfiger', N'USA',       1985),
(12, N'Calvin Klein',   N'USA',       1968);
GO

INSERT INTO dbo.Collection (CollectionID, Name, Season, Year) VALUES
(1,  N'Summer Breeze',    N'Summer',  2024),
(2,  N'Winter Warm',      N'Winter',  2024),
(3,  N'Spring Colors',    N'Spring',  2024),
(4,  N'Autumn Leaves',    N'Autumn',  2024),
(5,  N'Sport Line',       N'Spring',  2025),
(6,  N'Urban Style',      N'Summer',  2025),
(7,  N'Classic',          N'Autumn',  2024),
(8,  N'Eco Friendly',     N'Spring',  2025),
(9,  N'Premium Selection',N'Winter',  2024),
(10, N'Street Fashion',   N'Summer',  2024),
(11, N'Business Casual',  N'Autumn',  2025),
(12, N'Sportswear Pro',   N'Winter',  2025);
GO

INSERT INTO dbo.Product (ProductID, Name, Price, Color) VALUES
(1,  N'T-Shirt Nike Dri-Fit',        2990.00,  N'Black'),
(2,  N'Sneakers Adidas Ultraboost',  12990.00, N'White'),
(3,  N'Jeans Levi''s 501',           8990.00,  N'Blue'),
(4,  N'Coat Zara',                   15990.00, N'Beige'),
(5,  N'Hoodie Puma',                 4990.00,  N'Grey'),
(6,  N'Shirt H&M',                   2990.00,  N'White'),
(7,  N'Jacket Nike',                 9990.00,  N'Black'),
(8,  N'Sneakers Converse',           5990.00,  N'Red'),
(9,  N'Dress Zara',                  5490.00,  N'Pink'),
(10, N'Sweatpants Adidas',           3990.00,  N'Blue'),
(11, N'T-Shirt Uniqlo',              1990.00,  N'White'),
(12, N'Sneakers Puma',               7990.00,  N'Black'),
(13, N'Blazer Tommy Hilfiger',      12990.00, N'Navy'),
(14, N'Jeans Calvin Klein',          7990.00,  N'Black');
GO

INSERT INTO dbo.Size (SizeID, Name, SizeType) VALUES
(1,  N'XS', N'International'),
(2,  N'S',  N'International'),
(3,  N'M',  N'International'),
(4,  N'L',  N'International'),
(5,  N'XL', N'International'),
(6,  N'XXL',N'International'),
(7,  N'38', N'European'),
(8,  N'40', N'European'),
(9,  N'42', N'European'),
(10, N'44', N'European'),
(11, N'46', N'European'),
(12, N'48', N'European');
GO

INSERT INTO dbo.Category (CategoryID, Name) VALUES
(1,  N'T-Shirts'),
(2,  N'Sneakers'),
(3,  N'Jeans'),
(4,  N'Coats'),
(5,  N'Hoodies'),
(6,  N'Shirts'),
(7,  N'Jackets'),
(8,  N'Dresses'),
(9,  N'Sweatpants'),
(10, N'Blazers'),
(11, N'Accessories'),
(12, N'Shorts');
GO

INSERT INTO dbo.Material (MaterialID, Name) VALUES
(1,  N'Cotton'),
(2,  N'Polyester'),
(3,  N'Wool'),
(4,  N'Leather'),
(5,  N'Nylon'),
(6,  N'Viscose'),
(7,  N'Elastane'),
(8,  N'Linen'),
(9,  N'Denim'),
(10, N'Cashmere'),
(11, N'Silk'),
(12, N'Rubber');
GO

-- ==============================================================================
-- 4. Populate Edge Tables
-- ==============================================================================

-- Produces (Brand -> Product)
INSERT INTO dbo.Produces ($from_id, $to_id, DateProduced) VALUES
((SELECT $node_id FROM dbo.Brand WHERE BrandID = 1),  (SELECT $node_id FROM dbo.Product WHERE ProductID = 1),  '2024-01-15'),
((SELECT $node_id FROM dbo.Brand WHERE BrandID = 1),  (SELECT $node_id FROM dbo.Product WHERE ProductID = 7),  '2024-02-10'),
((SELECT $node_id FROM dbo.Brand WHERE BrandID = 2),  (SELECT $node_id FROM dbo.Product WHERE ProductID = 2),  '2024-03-01'),
((SELECT $node_id FROM dbo.Brand WHERE BrandID = 2),  (SELECT $node_id FROM dbo.Product WHERE ProductID = 10), '2024-04-20'),
((SELECT $node_id FROM dbo.Brand WHERE BrandID = 3),  (SELECT $node_id FROM dbo.Product WHERE ProductID = 5),  '2024-02-28'),
((SELECT $node_id FROM dbo.Brand WHERE BrandID = 3),  (SELECT $node_id FROM dbo.Product WHERE ProductID = 12), '2024-05-15'),
((SELECT $node_id FROM dbo.Brand WHERE BrandID = 4),  (SELECT $node_id FROM dbo.Product WHERE ProductID = 4),  '2024-01-10'),
((SELECT $node_id FROM dbo.Brand WHERE BrandID = 4),  (SELECT $node_id FROM dbo.Product WHERE ProductID = 9),  '2024-03-05'),
((SELECT $node_id FROM dbo.Brand WHERE BrandID = 5),  (SELECT $node_id FROM dbo.Product WHERE ProductID = 6),  '2024-06-01'),
((SELECT $node_id FROM dbo.Brand WHERE BrandID = 6),  (SELECT $node_id FROM dbo.Product WHERE ProductID = 3),  '2024-02-14'),
((SELECT $node_id FROM dbo.Brand WHERE BrandID = 6),  (SELECT $node_id FROM dbo.Product WHERE ProductID = 14), '2024-07-01'),
((SELECT $node_id FROM dbo.Brand WHERE BrandID = 9),  (SELECT $node_id FROM dbo.Product WHERE ProductID = 11), '2024-04-10'),
((SELECT $node_id FROM dbo.Brand WHERE BrandID = 11), (SELECT $node_id FROM dbo.Product WHERE ProductID = 13), '2024-05-20'),
((SELECT $node_id FROM dbo.Brand WHERE BrandID = 8),  (SELECT $node_id FROM dbo.Product WHERE ProductID = 8),  '2024-03-15');
GO

-- Includes (Collection -> Product)
INSERT INTO dbo.Includes ($from_id, $to_id, DateAdded) VALUES
((SELECT $node_id FROM dbo.Collection WHERE CollectionID = 1), (SELECT $node_id FROM dbo.Product WHERE ProductID = 1),  '2024-05-01'),
((SELECT $node_id FROM dbo.Collection WHERE CollectionID = 1), (SELECT $node_id FROM dbo.Product WHERE ProductID = 8),  '2024-05-01'),
((SELECT $node_id FROM dbo.Collection WHERE CollectionID = 2), (SELECT $node_id FROM dbo.Product WHERE ProductID = 4),  '2024-09-15'),
((SELECT $node_id FROM dbo.Collection WHERE CollectionID = 2), (SELECT $node_id FROM dbo.Product WHERE ProductID = 7),  '2024-09-15'),
((SELECT $node_id FROM dbo.Collection WHERE CollectionID = 3), (SELECT $node_id FROM dbo.Product WHERE ProductID = 6),  '2024-02-01'),
((SELECT $node_id FROM dbo.Collection WHERE CollectionID = 3), (SELECT $node_id FROM dbo.Product WHERE ProductID = 11), '2024-02-01'),
((SELECT $node_id FROM dbo.Collection WHERE CollectionID = 4), (SELECT $node_id FROM dbo.Product WHERE ProductID = 13), '2024-08-01'),
((SELECT $node_id FROM dbo.Collection WHERE CollectionID = 5), (SELECT $node_id FROM dbo.Product WHERE ProductID = 2),  '2024-12-01'),
((SELECT $node_id FROM dbo.Collection WHERE CollectionID = 5), (SELECT $node_id FROM dbo.Product WHERE ProductID = 10), '2024-12-01'),
((SELECT $node_id FROM dbo.Collection WHERE CollectionID = 6), (SELECT $node_id FROM dbo.Product WHERE ProductID = 5),  '2025-01-15'),
((SELECT $node_id FROM dbo.Collection WHERE CollectionID = 6), (SELECT $node_id FROM dbo.Product WHERE ProductID = 12), '2025-01-15'),
((SELECT $node_id FROM dbo.Collection WHERE CollectionID = 7), (SELECT $node_id FROM dbo.Product WHERE ProductID = 3),  '2024-07-01'),
((SELECT $node_id FROM dbo.Collection WHERE CollectionID = 8), (SELECT $node_id FROM dbo.Product WHERE ProductID = 11), '2024-11-01'),
((SELECT $node_id FROM dbo.Collection WHERE CollectionID = 9), (SELECT $node_id FROM dbo.Product WHERE ProductID = 13), '2024-10-01'),
((SELECT $node_id FROM dbo.Collection WHERE CollectionID = 10),(SELECT $node_id FROM dbo.Product WHERE ProductID = 9),  '2024-06-01');
GO

-- Has_Size (Product -> Size)
INSERT INTO dbo.Has_Size ($from_id, $to_id, StockQuantity) VALUES
((SELECT $node_id FROM dbo.Product WHERE ProductID = 1),  (SELECT $node_id FROM dbo.Size WHERE SizeID = 2),  50),
((SELECT $node_id FROM dbo.Product WHERE ProductID = 1),  (SELECT $node_id FROM dbo.Size WHERE SizeID = 3),  80),
((SELECT $node_id FROM dbo.Product WHERE ProductID = 1),  (SELECT $node_id FROM dbo.Size WHERE SizeID = 4),  60),
((SELECT $node_id FROM dbo.Product WHERE ProductID = 2),  (SELECT $node_id FROM dbo.Size WHERE SizeID = 8),  30),
((SELECT $node_id FROM dbo.Product WHERE ProductID = 2),  (SELECT $node_id FROM dbo.Size WHERE SizeID = 9),  45),
((SELECT $node_id FROM dbo.Product WHERE ProductID = 3),  (SELECT $node_id FROM dbo.Size WHERE SizeID = 3),  40),
((SELECT $node_id FROM dbo.Product WHERE ProductID = 3),  (SELECT $node_id FROM dbo.Size WHERE SizeID = 4),  55),
((SELECT $node_id FROM dbo.Product WHERE ProductID = 3),  (SELECT $node_id FROM dbo.Size WHERE SizeID = 5),  35),
((SELECT $node_id FROM dbo.Product WHERE ProductID = 4),  (SELECT $node_id FROM dbo.Size WHERE SizeID = 3),  20),
((SELECT $node_id FROM dbo.Product WHERE ProductID = 4),  (SELECT $node_id FROM dbo.Size WHERE SizeID = 4),  25),
((SELECT $node_id FROM dbo.Product WHERE ProductID = 5),  (SELECT $node_id FROM dbo.Size WHERE SizeID = 2),  70),
((SELECT $node_id FROM dbo.Product WHERE ProductID = 5),  (SELECT $node_id FROM dbo.Size WHERE SizeID = 3),  90),
((SELECT $node_id FROM dbo.Product WHERE ProductID = 5),  (SELECT $node_id FROM dbo.Size WHERE SizeID = 4),  65),
((SELECT $node_id FROM dbo.Product WHERE ProductID = 6),  (SELECT $node_id FROM dbo.Size WHERE SizeID = 3),  35),
((SELECT $node_id FROM dbo.Product WHERE ProductID = 6),  (SELECT $node_id FROM dbo.Size WHERE SizeID = 4),  40),
((SELECT $node_id FROM dbo.Product WHERE ProductID = 7),  (SELECT $node_id FROM dbo.Size WHERE SizeID = 3),  25),
((SELECT $node_id FROM dbo.Product WHERE ProductID = 7),  (SELECT $node_id FROM dbo.Size WHERE SizeID = 4),  30),
((SELECT $node_id FROM dbo.Product WHERE ProductID = 7),  (SELECT $node_id FROM dbo.Size WHERE SizeID = 5),  20),
((SELECT $node_id FROM dbo.Product WHERE ProductID = 8),  (SELECT $node_id FROM dbo.Size WHERE SizeID = 8),  40),
((SELECT $node_id FROM dbo.Product WHERE ProductID = 8),  (SELECT $node_id FROM dbo.Size WHERE SizeID = 9),  50),
((SELECT $node_id FROM dbo.Product WHERE ProductID = 9),  (SELECT $node_id FROM dbo.Size WHERE SizeID = 2),  30),
((SELECT $node_id FROM dbo.Product WHERE ProductID = 9),  (SELECT $node_id FROM dbo.Size WHERE SizeID = 3),  45),
((SELECT $node_id FROM dbo.Product WHERE ProductID = 10), (SELECT $node_id FROM dbo.Size WHERE SizeID = 3),  60),
((SELECT $node_id FROM dbo.Product WHERE ProductID = 10), (SELECT $node_id FROM dbo.Size WHERE SizeID = 4),  50),
((SELECT $node_id FROM dbo.Product WHERE ProductID = 11), (SELECT $node_id FROM dbo.Size WHERE SizeID = 2),  100),
((SELECT $node_id FROM dbo.Product WHERE ProductID = 11), (SELECT $node_id FROM dbo.Size WHERE SizeID = 3),  120),
((SELECT $node_id FROM dbo.Product WHERE ProductID = 11), (SELECT $node_id FROM dbo.Size WHERE SizeID = 4),  90),
((SELECT $node_id FROM dbo.Product WHERE ProductID = 12), (SELECT $node_id FROM dbo.Size WHERE SizeID = 8),  35),
((SELECT $node_id FROM dbo.Product WHERE ProductID = 12), (SELECT $node_id FROM dbo.Size WHERE SizeID = 9),  40),
((SELECT $node_id FROM dbo.Product WHERE ProductID = 13), (SELECT $node_id FROM dbo.Size WHERE SizeID = 3),  15),
((SELECT $node_id FROM dbo.Product WHERE ProductID = 13), (SELECT $node_id FROM dbo.Size WHERE SizeID = 4),  20),
((SELECT $node_id FROM dbo.Product WHERE ProductID = 14), (SELECT $node_id FROM dbo.Size WHERE SizeID = 3),  25),
((SELECT $node_id FROM dbo.Product WHERE ProductID = 14), (SELECT $node_id FROM dbo.Size WHERE SizeID = 4),  30);
GO

-- Belongs_To (Product -> Category)
INSERT INTO dbo.Belongs_To ($from_id, $to_id, AssignedDate) VALUES
((SELECT $node_id FROM dbo.Product WHERE ProductID = 1),  (SELECT $node_id FROM dbo.Category WHERE CategoryID = 1),  '2024-01-15'),
((SELECT $node_id FROM dbo.Product WHERE ProductID = 2),  (SELECT $node_id FROM dbo.Category WHERE CategoryID = 2),  '2024-03-01'),
((SELECT $node_id FROM dbo.Product WHERE ProductID = 3),  (SELECT $node_id FROM dbo.Category WHERE CategoryID = 3),  '2024-02-14'),
((SELECT $node_id FROM dbo.Product WHERE ProductID = 4),  (SELECT $node_id FROM dbo.Category WHERE CategoryID = 4),  '2024-01-10'),
((SELECT $node_id FROM dbo.Product WHERE ProductID = 5),  (SELECT $node_id FROM dbo.Category WHERE CategoryID = 5),  '2024-02-28'),
((SELECT $node_id FROM dbo.Product WHERE ProductID = 6),  (SELECT $node_id FROM dbo.Category WHERE CategoryID = 6),  '2024-06-01'),
((SELECT $node_id FROM dbo.Product WHERE ProductID = 7),  (SELECT $node_id FROM dbo.Category WHERE CategoryID = 7),  '2024-02-10'),
((SELECT $node_id FROM dbo.Product WHERE ProductID = 8),  (SELECT $node_id FROM dbo.Category WHERE CategoryID = 2),  '2024-03-15'),
((SELECT $node_id FROM dbo.Product WHERE ProductID = 9),  (SELECT $node_id FROM dbo.Category WHERE CategoryID = 8),  '2024-03-05'),
((SELECT $node_id FROM dbo.Product WHERE ProductID = 10), (SELECT $node_id FROM dbo.Category WHERE CategoryID = 9),  '2024-04-20'),
((SELECT $node_id FROM dbo.Product WHERE ProductID = 11), (SELECT $node_id FROM dbo.Category WHERE CategoryID = 1),  '2024-04-10'),
((SELECT $node_id FROM dbo.Product WHERE ProductID = 12), (SELECT $node_id FROM dbo.Category WHERE CategoryID = 2),  '2024-05-15'),
((SELECT $node_id FROM dbo.Product WHERE ProductID = 13), (SELECT $node_id FROM dbo.Category WHERE CategoryID = 10), '2024-05-20'),
((SELECT $node_id FROM dbo.Product WHERE ProductID = 14), (SELECT $node_id FROM dbo.Category WHERE CategoryID = 3),  '2024-07-01');
GO

-- Made_Of (Product -> Material)
INSERT INTO dbo.Made_Of ($from_id, $to_id, Percentage) VALUES
((SELECT $node_id FROM dbo.Product WHERE ProductID = 1),  (SELECT $node_id FROM dbo.Material WHERE MaterialID = 1),  100.00),
((SELECT $node_id FROM dbo.Product WHERE ProductID = 2),  (SELECT $node_id FROM dbo.Material WHERE MaterialID = 2),  60.00),
((SELECT $node_id FROM dbo.Product WHERE ProductID = 2),  (SELECT $node_id FROM dbo.Material WHERE MaterialID = 5),  40.00),
((SELECT $node_id FROM dbo.Product WHERE ProductID = 3),  (SELECT $node_id FROM dbo.Material WHERE MaterialID = 9),  100.00),
((SELECT $node_id FROM dbo.Product WHERE ProductID = 4),  (SELECT $node_id FROM dbo.Material WHERE MaterialID = 3),  80.00),
((SELECT $node_id FROM dbo.Product WHERE ProductID = 4),  (SELECT $node_id FROM dbo.Material WHERE MaterialID = 6),  20.00),
((SELECT $node_id FROM dbo.Product WHERE ProductID = 5),  (SELECT $node_id FROM dbo.Material WHERE MaterialID = 1),  70.00),
((SELECT $node_id FROM dbo.Product WHERE ProductID = 5),  (SELECT $node_id FROM dbo.Material WHERE MaterialID = 2),  30.00),
((SELECT $node_id FROM dbo.Product WHERE ProductID = 6),  (SELECT $node_id FROM dbo.Material WHERE MaterialID = 1),  100.00),
((SELECT $node_id FROM dbo.Product WHERE ProductID = 7),  (SELECT $node_id FROM dbo.Material WHERE MaterialID = 5),  60.00),
((SELECT $node_id FROM dbo.Product WHERE ProductID = 7),  (SELECT $node_id FROM dbo.Material WHERE MaterialID = 2),  40.00),
((SELECT $node_id FROM dbo.Product WHERE ProductID = 8),  (SELECT $node_id FROM dbo.Material WHERE MaterialID = 1),  50.00),
((SELECT $node_id FROM dbo.Product WHERE ProductID = 8),  (SELECT $node_id FROM dbo.Material WHERE MaterialID = 12), 50.00),
((SELECT $node_id FROM dbo.Product WHERE ProductID = 9),  (SELECT $node_id FROM dbo.Material WHERE MaterialID = 6),  70.00),
((SELECT $node_id FROM dbo.Product WHERE ProductID = 9),  (SELECT $node_id FROM dbo.Material WHERE MaterialID = 7),  30.00),
((SELECT $node_id FROM dbo.Product WHERE ProductID = 10), (SELECT $node_id FROM dbo.Material WHERE MaterialID = 1),  50.00),
((SELECT $node_id FROM dbo.Product WHERE ProductID = 10), (SELECT $node_id FROM dbo.Material WHERE MaterialID = 2),  50.00),
((SELECT $node_id FROM dbo.Product WHERE ProductID = 11), (SELECT $node_id FROM dbo.Material WHERE MaterialID = 1),  100.00),
((SELECT $node_id FROM dbo.Product WHERE ProductID = 12), (SELECT $node_id FROM dbo.Material WHERE MaterialID = 4),  40.00),
((SELECT $node_id FROM dbo.Product WHERE ProductID = 12), (SELECT $node_id FROM dbo.Material WHERE MaterialID = 12), 60.00),
((SELECT $node_id FROM dbo.Product WHERE ProductID = 13), (SELECT $node_id FROM dbo.Material WHERE MaterialID = 3),  60.00),
((SELECT $node_id FROM dbo.Product WHERE ProductID = 13), (SELECT $node_id FROM dbo.Material WHERE MaterialID = 6),  40.00),
((SELECT $node_id FROM dbo.Product WHERE ProductID = 14), (SELECT $node_id FROM dbo.Material WHERE MaterialID = 9),  90.00),
((SELECT $node_id FROM dbo.Product WHERE ProductID = 14), (SELECT $node_id FROM dbo.Material WHERE MaterialID = 7),  10.00);
GO

-- ==============================================================================
-- 5. MATCH Queries (chains of 3+ nodes)
-- ==============================================================================

PRINT '=== Query 1: Find all categories of products produced by Nike ===';
SELECT DISTINCT
    b.Name AS BrandName,
    p.Name AS ProductName,
    c.Name AS CategoryName
FROM
    dbo.Brand b,
    dbo.Produces pr,
    dbo.Product p,
    dbo.Belongs_To bt,
    dbo.Category c
WHERE
    MATCH(b-(pr)->p-(bt)->c)
    AND b.Name = N'Nike';
GO

PRINT '=== Query 2: Find all sizes of products from Summer Breeze collection ===';
SELECT DISTINCT
    col.Name AS CollectionName,
    p.Name AS ProductName,
    s.Name AS SizeName
FROM
    dbo.Collection col,
    dbo.Includes inc,
    dbo.Product p,
    dbo.Has_Size hs,
    dbo.Size s
WHERE
    MATCH(col-(inc)->p-(hs)->s)
    AND col.Name = N'Summer Breeze';
GO

PRINT '=== Query 3: Find brands producing products made of Cotton ===';
SELECT DISTINCT
    b.Name AS BrandName,
    p.Name AS ProductName,
    m.Name AS MaterialName
FROM
    dbo.Brand b,
    dbo.Produces pr,
    dbo.Product p,
    dbo.Made_Of mo,
    dbo.Material m
WHERE
    MATCH(b-(pr)->p-(mo)->m)
    AND m.Name = N'Cotton';
GO

PRINT '=== Query 4: Find collections containing T-Shirt products ===';
SELECT DISTINCT
    col.Name AS CollectionName,
    p.Name AS ProductName,
    c.Name AS CategoryName
FROM
    dbo.Collection col,
    dbo.Includes inc,
    dbo.Product p,
    dbo.Belongs_To bt,
    dbo.Category c
WHERE
    MATCH(col-(inc)->p-(bt)->c)
    AND c.Name = N'T-Shirts';
GO

PRINT '=== Query 5: Find size L products produced by Adidas ===';
SELECT DISTINCT
    b.Name AS BrandName,
    p.Name AS ProductName,
    s.Name AS SizeName
FROM
    dbo.Brand b,
    dbo.Produces pr,
    dbo.Product p,
    dbo.Has_Size hs,
    dbo.Size s
WHERE
    MATCH(b-(pr)->p-(hs)->s)
    AND b.Name = N'Adidas'
    AND s.Name = N'L';
GO

-- ==============================================================================
-- 6. SHORTEST_PATH Queries (with LAST_NODE and STRING_AGG)
-- ==============================================================================

PRINT '=== Query 6a: SHORTEST_PATH from Brand to Category via Products (pattern {1,5}) ===';
SELECT
    b.Name AS BrandName,
    STRING_AGG(p.Name, ' -> ') WITHIN GROUP (GRAPH PATH) AS ProductChain,
    LAST_VALUE(p.Name) WITHIN GROUP (GRAPH PATH) AS LastProduct,
    c.Name AS CategoryName
FROM
    dbo.Brand AS b,
    dbo.Produces FOR PATH AS pr,
    dbo.Product FOR PATH AS p,
    dbo.Belongs_To AS bt,
    dbo.Category AS c
WHERE
    MATCH(SHORTEST_PATH(b(-(pr)->p){1,5}) AND LAST_NODE(p)-(bt)->c)
ORDER BY
    b.Name, c.Name;
GO

PRINT '=== Query 6b: SHORTEST_PATH from Collection to Size via Products (pattern {1,3}) ===';
SELECT
    col.Name AS CollectionName,
    STRING_AGG(p.Name, ' -> ') WITHIN GROUP (GRAPH PATH) AS ProductChain,
    LAST_VALUE(p.Name) WITHIN GROUP (GRAPH PATH) AS LastProduct,
    s.Name AS SizeName
FROM
    dbo.Collection AS col,
    dbo.Includes FOR PATH AS inc,
    dbo.Product FOR PATH AS p,
    dbo.Has_Size AS hs,
    dbo.Size AS s
WHERE
    MATCH(SHORTEST_PATH(col(-(inc)->p){1,3}) AND LAST_NODE(p)-(hs)->s)
ORDER BY
    col.Name, s.Name;
GO

PRINT '=== Script completed ===';
GO
