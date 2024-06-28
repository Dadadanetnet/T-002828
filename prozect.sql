-- Создание таблицы пользователей
CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    PasswordHash NVARCHAR(255) NOT NULL,
    PhoneNumber NVARCHAR(15),
    StreetAddress NVARCHAR(255),
    City NVARCHAR(50),
    Country NVARCHAR(50),
    DateJoined DATETIME DEFAULT GETDATE()
);

-- Создание таблицы товарных категорий
CREATE TABLE ProductCategories (
    CategoryID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(50) NOT NULL
);

-- Создание таблицы продуктов
CREATE TABLE Items (
    ItemID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL,
    CategoryID INT NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    StockQuantity INT NOT NULL,
    Description NVARCHAR(255),
    ImageLink NVARCHAR(255),
    FOREIGN KEY (CategoryID) REFERENCES ProductCategories(CategoryID)
);

-- Создание таблицы покупок
CREATE TABLE Purchases (
    PurchaseID INT PRIMARY KEY IDENTITY(1,1),
    PurchaseDate DATETIME DEFAULT GETDATE(),
    OrderStatus NVARCHAR(50) NOT NULL,
    UserID INT NOT NULL,
    TotalCost DECIMAL(10, 2) NOT NULL,
    ShippingAddress NVARCHAR(255) NOT NULL,
    PaymentType NVARCHAR(50) NOT NULL,
    Notes NVARCHAR(255),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Создание таблицы деталей покупок
CREATE TABLE PurchaseDetails (
    PurchaseDetailID INT PRIMARY KEY IDENTITY(1,1),
    PurchaseID INT NOT NULL,
    ItemID INT NOT NULL,
    Quantity INT NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (PurchaseID) REFERENCES Purchases(PurchaseID),
    FOREIGN KEY (ItemID) REFERENCES Items(ItemID)
);

-- Пример заполнения таблицы категорий товаров
INSERT INTO ProductCategories (Name) VALUES
('Мужская одежда'),
('Женская одежда'),
('Обувь'),
('Аксессуары');

-- Пример заполнения таблицы продуктов
INSERT INTO Items (Name, CategoryID, Price, StockQuantity, Description, ImageLink) VALUES
('Куртка мужская', 1, 3500.00, 40, 'Утепленная зимняя куртка', 'https://example.com/jacket.jpg'),
('Юбка женская', 2, 1200.00, 60, 'Короткая летняя юбка', 'https://example.com/skirt.jpg'),
('Ботинки', 3, 5000.00, 25, 'Кожаные ботинки', 'https://example.com/boots.jpg'),
('Сумка женская', 4, 2500.00, 30, 'Элегантная сумка', 'https://example.com/bag.jpg');

-- Пример заполнения таблицы пользователей
INSERT INTO Users (FirstName, LastName, Email, PasswordHash, PhoneNumber, StreetAddress, City, Country) VALUES
('Алексей', 'Смирнов', 'smirnov@example.com', 'hashedpassword123', '1112223333', 'ул. Мира, д. 5', 'Новосибирск', 'Россия'),
('Мария', 'Иванова', 'ivanova@example.com', 'hashedpassword456', '4445556666', 'ул. Победы, д. 10', 'Екатеринбург', 'Россия');

-- Пример создания покупки
INSERT INTO Purchases (OrderStatus, UserID, TotalCost, ShippingAddress, PaymentType, Notes) VALUES
('Новый', 1, 8500.00, 'ул. Мира, д. 5, Новосибирск, Россия', 'Кредитная карта', 'Доставка вечером');

-- Пример добавления деталей покупки
INSERT INTO PurchaseDetails (PurchaseID, ItemID, Quantity, Price) VALUES
(1, 1, 1, 3500.00),  -- 1 куртка мужская
(1, 3, 1, 5000.00);  -- 1 пара ботинок

-- Вывод всех покупок с деталями
SELECT 
    Purchases.PurchaseID,
    Purchases.PurchaseDate,
    Purchases.OrderStatus,
    Users.FirstName + ' ' + Users.LastName AS UserName,
    Purchases.TotalCost,
    Purchases.ShippingAddress,
    Purchases.PaymentType,
    Purchases.Notes,
    Items.Name AS ItemName,
    PurchaseDetails.Quantity,
    PurchaseDetails.Price
FROM 
    Purchases
JOIN 
    Users ON Purchases.UserID = Users.UserID
JOIN 
    PurchaseDetails ON Purchases.PurchaseID = PurchaseDetails.PurchaseID
JOIN 
    Items ON PurchaseDetails.ItemID = Items.ItemID;
