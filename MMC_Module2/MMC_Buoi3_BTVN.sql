---- question 1
INSERT INTO Department (DepartmentName)
VALUES 
    ('Logistics'),
    ('Customer Service'),
    ('Research and Development'),
    ('Finance'),
    ('Human Resources'),
    ('Quality Assurance'),
    ('IT Support'),
    ('Administration'),
    ('Legal'),
    ('Production');

-- Add data Position
ALTER TABLE `Position`
MODIFY COLUMN `PositionName` ENUM('UI/UX Designer','System Administrator','Business Analyst','Marketing Manager','Financial Analyst','Software Engineer','Network Engineer','HR Manager','Customer Service Representative','Project Coordinator');

INSERT INTO Account (Email, Username, FullName, DepartmentID, PositionID, CreateDate)
VALUES 
('phamvannghia123@gmail.com', 'nghiavan', 'Nguyễn Văn Nghĩa', 1, 2, '2022-05-09'),
('tranvanbinh456@gmail.com', 'binhtran', 'Trần Văn Bình', 2, 3, '2019-07-19'),
('lethithu789@gmail.com', 'thule', 'Lê Thị Thu', 3, 4, '2020-09-06'),
('phamvannam101112@gmail.com', 'nampham', 'Phạm Văn Nam', 4, 1, '2019-12-25'),
('nguyenthanh131415@gmail.com', 'thanhnguyen', 'Nguyễn Thành', 5, 2, '2023-08-27'),
('hoangvandat161718@gmail.com', 'dathoang', 'Hoàng Văn Đạt', 6, 3, '2018-11-09'),
('tranthanhthao192021@gmail.com', 'thaothanh', 'Trần Thanh Thảo', 7, 4, '2022-07-20'),
('nguyenthilananh222324@gmail.com', 'anhnguyen', 'Nguyễn Thị Lan Anh', 8, 1, '2023-02-14'),
('lethiha252627@gmail.com', 'hale', 'Lê Thị Hà', 9, 2, '2019-11-24'),
('phamvannghia282930@gmail.com', 'nghiapham', 'Phạm Văn Nghĩa', 10, 3, '2022-04-18');

INSERT INTO `Group` (GroupName, CreatorID, CreateDate)
VALUES 
    ('Research Team', 3, NOW()),
    ('Marketing Campaign', 4, NOW()),
    ('Financial Planning', 5, NOW()),
    ('HR Training', 6, NOW()),
    ('Quality Improvement', 7, NOW()),
    ('IT Projects', 8, NOW()),
    ('Administration Tasks', 9, NOW()),
    ('Legal Compliance', 10, NOW()),
    ('Production Planning', 1, NOW()),
    ('Customer Feedback', 2, NOW());

INSERT IGNORE INTO `Group` (GroupName, CreatorID, CreateDate)
VALUES 
    ('Research Team', 3, NOW()),
    ('Marketing Campaign', 4, NOW()),
    ('Financial Planning', 5, NOW()),
    ('HR Training', 6, NOW()),
    ('Quality Improvement', 7, NOW()),
    ('IT Projects', 8, NOW()),
    ('Administration Tasks', 9, NOW()),
    ('Legal Compliance', 10, NOW()),
    ('Production Planning', 1, NOW()),
    ('Customer Feedback', 2, NOW());


-- Assuming you're using MySQL's `AUTO_INCREMENT` for GroupID, you don't need to specify it in the INSERT statement.
INSERT INTO GroupAccount (GroupID, AccountID, JoinDate)
VALUES 
    (11, 11, NOW()),
    (12, 12, NOW()),
    (13, 13, NOW()),
    (14, 14, NOW()),
    (15, 15, NOW()),
    (16, 16, NOW()),
    (17, 17, NOW()),
    (18, 18, NOW()),
    (19, 19, NOW()),
    (20, 20, NOW());


ALTER TABLE TypeQuestion MODIFY COLUMN TypeName VARCHAR(30);

INSERT INTO TypeQuestion (TypeName)
VALUES 
    ('Fill-in-the-Blank'),
    ('True or False'),
    ('Matching'),
    ('Short Answer'),
    ('Code Explanation'),
    ('Diagram Interpretation'),
    ('Problem Solving'),
    ('Multiple Choice'),
    ('Coding Exercise');

INSERT INTO CategoryQuestion (CategoryName)
VALUES 
    ('Geography'),
    ('History'),
    ('Science'),
    ('Mathematics'),
    ('Literature'),
    ('Language'),
    ('Art'),
    ('Music'),
    ('Sports'),
    ('Technology');

-- Assuming you're using MySQL's `AUTO_INCREMENT` for ExamID, you don't need to specify it in the INSERT statement.
INSERT INTO Exam (`Code`, Title, CategoryID, Duration, CreatorID, CreateDate)
VALUES 
    ('EXAM001', 'Geography Test', 1, 60, 2, NOW()),
    ('EXAM002', 'Literature Quiz', 5, 45, 3, NOW()),
    ('EXAM003', 'Mathematics Exam', 4, 90, 4, NOW()),
    ('EXAM004', 'Science Test', 3, 60, 5, NOW()),
    ('EXAM005', 'Technology Quiz', 10, 45, 6, NOW()),
    ('EXAM006', 'History Exam', 2, 90, 7, NOW()),
    ('EXAM007', 'Language Test', 6,100,10,NOW());

-- Cau 2:
SELECT `DepartmentName`
from `Department`

-- Cau 3:
SELECT * FROM `Department`
WHERE `DepartmentName` = 'Sale'

--- Cau 4:
SELECT * FROM `Account`
WHERE LENGTH(`FullName`) = (SELECT MAX(LENGTH(`FullName`)) FROM `Account`);

-- Cau 5
SELECT * FROM `Account`
WHERE LENGTH(`FullName`) = (SELECT MAX(LENGTH(`FullName`)) FROM `Account`)
and `DepartmentID` = 3;

-- Cau 6:
SELECT * FROM `Group`
WHERE `CreateDate` < '2019-12-20';

--Cau 7:
SELECT QuestionID
FROM Answer
GROUP BY QuestionID
HAVING COUNT(*) >= 4;

-- Cau 8:
SELECT Code
FROM Exam
WHERE Duration >= 60 AND CreateDate < '2019-12-20';

-- Cau 9:
SELECT GroupName, CreateDate
FROM `Group`
ORDER BY CreateDate DESC
LIMIT 5;

-- Cau 10:
SELECT COUNT(*) AS num_employees
FROM `Department`
WHERE `DepartmentID` = 2

--- Cau 11:
SELECT * 
FROM `Account`
WHERE `Username` LIKE 'D%O';

-- Cau 12:
DELETE FROM Exam
WHERE CreateDate < '2019-12-20';


--Cau 13:
DELETE FROM Question
WHERE Content LIKE 'câu hỏi%';


-- Cau 14:
UPDATE Account
SET FullName = 'Lô Văn Đề', Email = 'lo.vande@mmc.edu.vn'
WHERE AccountID = 5;

-- Cau 15 
UPDATE Account
SET `PositionID`= 4
WHERE AccountID = 5;
