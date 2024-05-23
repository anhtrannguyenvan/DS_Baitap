CREATE DATABASE Sales;
USE Sales

-- Tạo bảng CUSTOMER
CREATE TABLE CUSTOMER (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Phone VARCHAR(15) NOT NULL,
    Email VARCHAR(255) NOT NULL,
    Address VARCHAR(255) NOT NULL,
    Note TEXT
);

-- Tạo bảng CAR
CREATE TABLE CAR (
    CarID INT PRIMARY KEY,
    Maker ENUM('HONDA', 'TOYOTA', 'NISSAN') NOT NULL,
    Model VARCHAR(255) NOT NULL,
    Year INT NOT NULL,
    Color VARCHAR(50) NOT NULL,
    Note TEXT
);

-- Tạo bảng CAR_ORDER
CREATE TABLE CAR_ORDER (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT,
    CarID INT,
    Amount INT DEFAULT 1,
    SalePrice DECIMAL(10, 2) NOT NULL,
    OrderDate DATE NOT NULL,
    DeliveryDate DATE,
    DeliveryAddress VARCHAR(255),
    Status INT DEFAULT 0,
    Note TEXT,
    FOREIGN KEY (CustomerID) REFERENCES CUSTOMER(CustomerID),
    FOREIGN KEY (CarID) REFERENCES CAR(CarID)
);

-- Thêm bản ghi vào bảng CUSTOMER
INSERT INTO CUSTOMER (CustomerID,Name, Phone, Email, Address, Note) VALUES
(1,'Nguyen Van A', '0901234567', 'nguyenvana@example.com', '123 Nguyen Trai, Hanoi', 'Khách hàng VIP'),
(2,'Le Thi B', '0912345678', 'lethib@example.com', '456 Le Loi, Da Nang', 'Khách hàng tiềm năng'),
(3,'Tran Van C', '0923456789', 'tranvanc@example.com', '789 Tran Hung Dao, HCMC', 'Khách hàng mới'),
(4,'Pham Thi D', '0934567890', 'phamthid@example.com', '321 Hai Ba Trung, Hue', 'Khách hàng thường xuyên'),
(5,'Hoang Van E', '0945678901', 'hoangvane@example.com', '654 Ly Thai To, Nha Trang', 'Khách hàng có yêu cầu đặc biệt');

-- Thêm bản ghi vào bảng CAR
INSERT INTO CAR (CarID, Maker, Model, Year, Color, Note) VALUES
(1, 'HONDA', 'Civic', 2020, 'Black', 'Xe mới nhập khẩu'),
(2, 'TOYOTA', 'Camry', 2021, 'White', 'Xe đã qua sử dụng'),
(3, 'NISSAN', 'Altima', 2019, 'Blue', 'Xe chính hãng'),
(4, 'HONDA', 'Accord', 2022, 'Red', 'Xe mới ra mắt'),
(5, 'TOYOTA', 'Corolla', 2023, 'Yellow', 'Phiên bản đặc biệt');

-- Thêm bản ghi vào bảng CAR_ORDER
INSERT INTO CAR_ORDER (CustomerID, CarID, Amount, SalePrice, OrderDate, DeliveryDate, DeliveryAddress, Status, Note) VALUES
(1, 1, 1, 30000.00, '2024-05-01', '2024-05-05', '123 Nguyen Trai, Hanoi', 1, 'Giao hàng đúng hẹn'),
(2, 2, 1, 25000.00, '2024-05-02', '2024-05-06', '456 Le Loi, Da Nang', 1, 'Khách hàng hài lòng'),
(3, 3, 1, 27000.00, '2024-05-03', '2024-05-07', '789 Tran Hung Dao, HCMC', 0, 'Đang chờ giao hàng'),
(4, 4, 2, 55000.00, '2024-05-04', NULL, '321 Hai Ba Trung, Hue', 0, 'Chờ xác nhận đơn hàng'),
(5, 5, 1, 22000.00, '2024-05-05', '2024-05-08', '654 Ly Thai To, Nha Trang', 2, 'Đơn hàng bị hủy');

-- Cau 2: Viết lệnh lấy ra thông tin của khách hàng: tên, số lượng oto khách hàng đã mua và sắp sếp tăng dần theo số lượng oto đã mua.
SELECT c.Name, Count(a.CarID) as NumberofCars
FROM Customer c
LEFT JOIN CAR_ORDER a on c.CustomerID = a.CustomerID
GROUP BY c.Name
ORDER BY Count(a.CarID) ASC;

-- Cau 3: Viết hàm (không có parameter) trả về tên hãng sản xuất đã bán được nhiều oto nhất trong năm nay.
DELIMITER $$

CREATE FUNCTION TopCarMakerThisYear()
RETURNS VARCHAR(50)
BEGIN
    DECLARE topMaker VARCHAR(50);
    DECLARE currentYear INT;
    
    -- Lấy năm hiện tại
    SET currentYear = YEAR(CURDATE());
    
    -- Tìm hãng sản xuất đã bán được nhiều ô tô nhất trong năm hiện tại
    SELECT c.Maker INTO topMaker
    FROM CAR_ORDER co
    JOIN CAR c ON co.CarID = c.CarID
    WHERE YEAR(co.OrderDate) = currentYear
    GROUP BY c.Maker
    ORDER BY SUM(co.Amount) DESC
    LIMIT 1;
    
    RETURN topMaker;
END$$

DELIMITER ;

SELECT TopCarMakerThisYear();
-- Cau 3: Viết 1 thủ tục (không có parameter) để xóa các đơn hàng đã bị hủy của những năm trước. In ra số lượng bản ghi đã bị xóa.
DELIMITER $$

CREATE PROCEDURE DeleteCanceledOrders()
BEGIN
    DECLARE deletedCount INT DEFAULT 0;
    
    -- Xóa các đơn hàng đã bị hủy trước năm hiện tại và đếm số lượng bản ghi đã bị xóa
    DELETE FROM CAR_ORDER
    WHERE Status = 2 AND YEAR(OrderDate) < YEAR(CURDATE());
    
    -- Lấy số lượng bản ghi đã bị xóa
    SET deletedCount = ROW_COUNT();
    
    -- In ra số lượng bản ghi đã bị xóa
    SELECT CONCAT('Số lượng đơn hàng đã bị xóa: ', deletedCount) AS Result;
END$$

DELIMITER ;

CALL DeleteCanceledOrders();

-- Cau 4: Viết 1 thủ tục (có CustomerID parameter) để in ra thông tin của các đơn hàng đã đặt hàng bao gồm: tên của khách hàng, mã đơn hàng, số lượng
-- oto và tên hãng sản xuất.
DELIMITER $$

CREATE PROCEDURE GetCustomerOrders(IN inputCustomerID INT)
BEGIN
    SELECT 
        c.Name AS CustomerName,
        co.OrderID AS OrderID,
        co.Amount AS CarAmount,
        car.Maker AS CarMaker
    FROM 
        CUSTOMER c
    JOIN 
        CAR_ORDER co ON c.CustomerID = co.CustomerID
    JOIN 
        CAR car ON co.CarID = car.CarID
    WHERE 
        c.CustomerID = inputCustomerID
        AND co.Status = 0; -- Chỉ lấy các đơn hàng đã đặt (trạng thái 0)
END$$

DELIMITER ;

CALL GetCustomerOrders(1);

-- Cau 6: Viết trigger để tránh trường hợp người dụng nhập thông tin không hợp lệ
-- vào database (DeliveryDate < OrderDate + 15).
DELIMITER $$

CREATE TRIGGER before_update_car_order
BEFORE UPDATE ON CAR_ORDER
FOR EACH ROW
BEGIN
    -- Kiểm tra điều kiện DeliveryDate < OrderDate + 15
    IF NEW.DeliveryDate < NEW.OrderDate + INTERVAL 15 DAY THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'DeliveryDate must be at least 15 days after OrderDate';
    END IF;
END$$

DELIMITER ;

INSERT INTO CAR_ORDER (CustomerID, CarID, Amount, SalePrice, OrderDate, DeliveryDate, DeliveryAddress, Status, Note)
VALUES (1, 1, 1, 30000.00, '2024-05-01', '2024-05-10', '123 Nguyen Trai, Hanoi', 0, 'Test invalid date');

