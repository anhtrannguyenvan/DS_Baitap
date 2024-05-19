-- CAU 1:Viết lệnh để lấy ra danh sách nhân viên và thông tin phòng ban của họ---
SELECT a.Username, a.FullName, b.DepartmentName
FROM TestingSystem.Account a
LEFT JOIN TestingSystem.Department b ON a.DepartmentID = b.DepartmentID;

-- CAU 2: Viết lệnh để lấy ra thông tin các account được tạo sau ngày 20/12/2010 ---
SELECT accountid, username, createdate
from TestingSystem.Account 
where createdate > '2010-12-20';

-- CAU 3: Viết lệnh để lấy ra tất cả các developer
SELECT a.AccountID,a.Username, a.FullName, p.PositionName
FROM Account a
LEFT JOIN position p ON a.PositionID = p.PositionID
WHERE p.PositionName = 'Dev';
-- Cau 4: Viết lệnh để lấy ra danh sách các phòng ban có >3 nhân viên
SELECT d.DepartmentID, d.DepartmentName, COUNT(a.AccountID) as NumberOfEmployees
FROM Department d
LEFT JOIN Account a ON d.DepartmentID = a.DepartmentID
GROUP BY d.DepartmentID, d.DepartmentName
HAVING COUNT(a.AccountID) > 3;

-- CAU 5:  Viết lệnh để lấy ra danh sách câu hỏi được sử dụng trong đề thi nhiều nhất
SELECT a.QuestionID, a.Content, COUNT(b.ExamID) as NumberOfExams
FROM Question a
JOIN ExamQuestion b ON a.QuestionID = b.QuestionID
GROUP BY a.QuestionID, a.Content
ORDER BY NumberOfExams DESC;
-- cau 6:  Thông kê mỗi category Question được sử dụng trong bao nhiêu Question
SELECT a.CategoryID, a.CategoryName, COUNT(b.QuestionID)
FROM CategoryQuestion a
LEFT JOIN Question b ON a.CategoryID = b.CategoryID
GROUP BY a.CategoryID, a.CategoryName
-- cau 7 : Thông kê mỗi Question được sử dụng trong bao nhiêu Exam
SELECT a.QuestionID, a.Content, COUNT(b.ExamID) as NumberOfExams
FROM Question a
LEFT JOIN ExamQuestion b ON a.QuestionID = b.QuestionID
GROUP BY a.QuestionID, a.Content;
-- Cau 8 : Lấy ra Question có nhiều câu trả lời nhất
SELECT q.QuestionID, q.Content, COUNT(a.AnswerID) as NumberOfAnswers
FROM Question q
JOIN Answer a ON q.QuestionID = a.QuestionID
GROUP BY q.QuestionID, q.Content
ORDER BY NumberOfAnswers DESC
LIMIT 1;
-- CAU 9: Thống kê số lượng account trong mỗi group
SELECT g.GroupID, g.GroupName, COUNT(ga.AccountID) AS NumberOfAccounts
FROM `Group` g
LEFT JOIN GroupAccount ga ON g.GroupID = ga.GroupID
GROUP BY g.GroupID, g.GroupName;
-- cau 10: Tìm chức vụ có ít người nhất
SELECT p.PositionID, p.PositionName, COUNT(a.AccountID) as Num_of_accounts
FROM Position p
LEFT JOIN Account a ON p.PositionID = a.PositionID
GROUP BY p.PositionID, p.PositionName
ORDER BY Num_of_accounts DESC
LIMIT 1;
-- Cau 11:  Thống kê mỗi phòng ban có bao nhiêu dev, test, scrum master, PM 
SELECT 
    d.DepartmentID,
    d.DepartmentName,
    SUM(CASE WHEN p.PositionName = 'Dev' THEN 1 ELSE 0 END) AS NumberOfDevs,
    SUM(CASE WHEN p.PositionName = 'Test' THEN 1 ELSE 0 END) AS NumberOfTests,
    SUM(CASE WHEN p.PositionName = 'Scrum Master' THEN 1 ELSE 0 END) AS NumberOfScrumMasters,
    SUM(CASE WHEN p.PositionName = 'PM' THEN 1 ELSE 0 END) AS NumberOfPMs
FROM 
    Department d
LEFT JOIN 
    `Account` a ON d.DepartmentID = a.DepartmentID
LEFT JOIN 
    `Position` p ON a.PositionID = p.PositionID
GROUP BY 
    d.DepartmentID, d.DepartmentName;
-- Cau 12: 
SELECT 
    q.QuestionID,
    q.Content AS QuestionContent,
    tq.TypeName AS QuestionType,
    a.FullName AS CreatorName,
    a.Email AS CreatorEmail,
    a.Username AS CreatorUsername,
    ans.Content AS AnswerContent,
    ans.isCorrect AS IsCorrectAnswer
FROM 
    Question q
JOIN 
    TypeQuestion tq ON q.TypeID = tq.TypeID
JOIN 
    `Account` a ON q.CreatorID = a.AccountID
LEFT JOIN 
    Answer ans ON q.QuestionID = ans.QuestionID;
-- CAU 13: Lấy ra số lượng câu hỏi của mỗi loại tự luận hay trắc nghiệm
SELECT 
    tq.TypeName AS QuestionType,
    COUNT(*) AS NumberOfQuestions
FROM 
    Question q
JOIN 
    TypeQuestion tq ON q.TypeID = tq.TypeID
GROUP BY 
    tq.TypeName;

-- Cau 14: Lấy ra group không có account nào
SELECT 
    g.GroupID,
    g.GroupName
FROM 
    `Group` g
LEFT JOIN 
    GroupAccount ga ON g.GroupID = ga.GroupID
WHERE 
    ga.GroupID IS NULL;
-- Cau 15: Lấy ra question không có answer nào
SELECT 
    q.QuestionID,
    q.Content AS QuestionContent
FROM 
    Question q
LEFT JOIN 
    Answer a ON q.QuestionID = a.QuestionID
WHERE 
    a.QuestionID IS NULL;

-- CAU 17: 
SELECT * FROM
(
    SELECT 
        a.*
    FROM 
        `Account` a
    JOIN 
        GroupAccount ga ON a.AccountID = ga.AccountID
    WHERE 
        ga.GroupID = 1
) AS Group1
UNION ALL
SELECT * FROM
(
    SELECT 
        a.*
    FROM 
        `Account` a
    JOIN 
        GroupAccount ga ON a.AccountID = ga.AccountID
    WHERE 
        ga.GroupID = 2
) AS Group2;

-- Cau 18: 
(
    SELECT 
        g.*
    FROM 
        `Group` g
    JOIN 
        (
            SELECT 
                GroupID,
                COUNT(AccountID) AS MemberCount
            FROM 
                GroupAccount
            GROUP BY 
                GroupID
            HAVING 
                MemberCount > 5
        ) AS GroupMemberCount ON g.GroupID = GroupMemberCount.GroupID
)
UNION ALL
(
    SELECT 
        g.*
    FROM 
        `Group` g
    JOIN 
        (
            SELECT 
                GroupID,
                COUNT(AccountID) AS MemberCount
            FROM 
                GroupAccount
            GROUP BY 
                GroupID
            HAVING 
                MemberCount < 7
        ) AS GroupMemberCount ON g.GroupID = GroupMemberCount.GroupID
);




