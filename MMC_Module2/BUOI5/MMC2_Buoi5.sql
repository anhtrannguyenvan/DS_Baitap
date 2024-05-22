-- Question 1: Tạo view có chứa danh sách nhân viên thuộc phòng ban Sale
CREATE VIEW SaleEmployee as
SELECT a.*
FROM Account a
JOIN Department d ON a.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'Sale';


-- Question 2: Tạo view có chứa các thông tin account tham gia nhiều group nhất
CREATE VIEW MostActiveAccounts AS
SELECT 
    a.*,
    COUNT(ga.GroupID) AS NumberOfGroups
FROM 
    `Account` a
JOIN 
    GroupAccount ga ON a.AccountID = ga.AccountID
GROUP BY 
    a.AccountID
ORDER BY 
    NumberOfGroups DESC
LIMIT 1;

-- Question 3: Tạo view có chứa những câu hỏi có content quá dài (Content quá 300 được coi là quá dài) và xoá nó đi
CREATE VIEW LongContentQuestions AS
SELECT 
    *
FROM 
    Question
WHERE 
    LENGTH(Content) > 300;
    
DELETE FROM Question WHERE LENGTH(Content) > 300;

-- Question 4: Tạo view chứa các phòng ban có nhiều nhân viên nhất
CREATE VIEW DepartmentsWithMostEmployees AS
SELECT 
    d.DepartmentID,
    d.DepartmentName,
    COUNT(a.AccountID) AS EmployeeCount
FROM 
    Department d
LEFT JOIN 
    `Account` a ON d.DepartmentID = a.DepartmentID
GROUP BY 
    d.DepartmentID, d.DepartmentName
HAVING 
    EmployeeCount = (
        SELECT 
            MAX(EmployeeCount)
        FROM 
            (
                SELECT 
                    COUNT(a.AccountID) AS EmployeeCount
                FROM 
                    Department d
                LEFT JOIN 
                    `Account` a ON d.DepartmentID = a.DepartmentID
                GROUP BY 
                    d.DepartmentID
            ) AS Subquery
    );

-- Question 5: Tạo view chứa các câu hỏi do user họ Nguyễn tạo
CREATE VIEW NguyenQuestions AS
SELECT 
    q.*,
    a.Username AS CreatorUsername,
    a.FullName AS CreatorFullName
FROM 
    Question q
JOIN 
    `Account` a ON q.CreatorID = a.AccountID
WHERE 
    a.FullName LIKE 'Nguyễn%';
