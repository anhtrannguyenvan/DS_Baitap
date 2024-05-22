-- Cau 1: Tạo store để người dùng nhập vào tên phòng ban và in ra tất cả các account thuộc phòng ban đó
DELIMITER //

CREATE PROCEDURE GetAccountsByDepartment(IN dept_name VARCHAR(30))
BEGIN
    SELECT a.*
    FROM Account a
    JOIN Department d ON a.DepartmentID = d.DepartmentID
    WHERE d.DepartmentName = dept_name;
END //

DELIMITER ;

CALL GetAccountsByDepartment('Sale');
-- Cau 2: Tạo store để in ra số lượng account trong mỗi group
DELIMITER //

CREATE PROCEDURE CountAccountsInGroups()
BEGIN
    SELECT g.GroupName, COUNT(a.AccountID) AS NumberOfAccounts
    FROM `Group` g
    LEFT JOIN GroupAccount a ON g.GroupID = a.GroupID
    GROUP BY g.GroupID;
END //

DELIMITER ;

CALL CountAccountsInGroups();
-- Cau 3: Tạo store để thống kê mỗi type question có bao nhiêu question được tạo trong tháng hiện tại
DROP PROCEDURE IF EXISTS CountQuestionInCurrentMonth;
DELIMITER //

CREATE PROCEDURE CountQuestionInCurrentMonth()
BEGIN
    DECLARE current_month_start DATE;
    DECLARE current_month_end DATE;

    SET current_month_start = CURDATE() - INTERVAL DAY(CURDATE()) - 1 DAY + INTERVAL 1 DAY;
    SET current_month_end = LAST_DAY(CURDATE());

    SELECT a.TypeName, COUNT(b.QuestionID) AS numberofquestions
    FROM TypeQuestion a
    LEFT JOIN Question b ON a.TypeID = b.TypeID
    WHERE b.CreatDate BETWEEN current_month_start AND current_month_end
    GROUP BY a.TypeID;
END //

DELIMITER ;

CALL CountQuestionInCurrentMonth;

-- cau 4: Tạo store để trả ra id của type question có nhiều câu hỏi nhất
DELIMITER //

CREATE PROCEDURE GetMostCommonTypeQuestionID()
BEGIN
    SELECT TypeID
    FROM Question
    GROUP BY TypeID
    ORDER BY COUNT(*) DESC
    LIMIT 1;
END //

DELIMITER ;
CALL GetMostCommonTypeQuestionID()

-- Cau 5:Sử dụng store ở question 4 để tìm ra tên của type question

DROP PROCEDURE IF EXISTS GetTypeQuestionNameForMostCommon;
DELIMITER //

CREATE PROCEDURE GetTypeQuestionNameForMostCommon()
BEGIN
    DECLARE most_common_type_id INT;
    
    -- Gọi stored procedure trước để lấy ID của loại câu hỏi có nhiều câu hỏi nhất
    CALL GetMostCommonTypeQuestionID() INTO most_common_type_id;
    
    -- Truy vấn để lấy tên của loại câu hỏi từ ID
    SELECT TypeName
    FROM TypeQuestion
    WHERE TypeID = most_common_type_id;
END //

DELIMITER ;


-- CAU 6: Viết 1 store cho phép người dùng nhập vào 1 chuỗi và trả về group có tên chứa chuỗi của người dùng nhập vào hoặc trả về user có username chứa chuỗi của
-- người dùng nhập vào
DELIMITER //

CREATE PROCEDURE SearchGroupOrUser(IN searchString VARCHAR(255))
BEGIN
    -- Check if searchString is not empty
    IF searchString IS NOT NULL AND searchString != '' THEN
        -- Search for groups containing the searchString
        SELECT `GroupID`, `GroupName`
        FROM `Group`
        WHERE `GroupName` LIKE CONCAT('%', searchString, '%');

        -- Search for users with usernames containing the searchString
        SELECT `AccountID`, `Username`
        FROM `Account`
        WHERE `Username` LIKE CONCAT('%', searchString, '%');
    ELSE
        -- If searchString is empty, return an error message
        SELECT 'Search string cannot be empty' AS 'Error';
    END IF;
END //

DELIMITER ;
CALL SearchGroupOrUser('dang');
-- Cau 7: Viết 1 store cho phép người dùng nhập vào thông tin fullName, email và trong store sẽ tự động gán:
DELIMITER //

CREATE PROCEDURE CreateUser(
    IN fullName NVARCHAR(50),
    IN email VARCHAR(50)
)
BEGIN
    DECLARE userName VARCHAR(50);
    DECLARE defaultPositionID TINYINT;
    DECLARE defaultDepartmentID TINYINT;
    
    -- Assign username from email
    SET userName = SUBSTRING_INDEX(email, '@', 1);
    
    -- Set default values
    SET defaultPositionID = (SELECT PositionID FROM Position WHERE PositionName = 'Dev');
    SET defaultDepartmentID = 11; -- Assuming 11 is the departmentID for the waiting room
    
    -- Insert into Account table
    INSERT INTO `Account` (Email, Username, FullName, DepartmentID, PositionID, CreateDate)
    VALUES (email, userName, fullName, defaultDepartmentID, defaultPositionID, NOW());
    
    -- Print success message
    SELECT 'User created successfully' AS Result;
END //

DELIMITER ;

-- Cau 8: Viết 1 store cho phép người dùng nhập vào Essay hoặc Multiple-Choice để thống kê câu hỏi essay hoặc multiple-choice nào có content dài nhất
DELIMITER //

CREATE PROCEDURE FindLongestQuestion(IN questionType VARCHAR(20))
BEGIN
    DECLARE maxContentLength INT;
    DECLARE maxQuestionID INT;

    -- Find the maximum content length for the specified question type
    SELECT MAX(LENGTH(Content)) INTO maxContentLength
    FROM Question
    WHERE TypeID = (SELECT TypeID FROM TypeQuestion WHERE TypeName = questionType);

    -- Find the question with the maximum content length
    SELECT QuestionID INTO maxQuestionID
    FROM Question
    WHERE LENGTH(Content) = maxContentLength AND TypeID = (SELECT TypeID FROM TypeQuestion WHERE TypeName = questionType)
    LIMIT 1;

    -- Print the result
    IF maxQuestionID IS NOT NULL THEN
        SELECT CONCAT('Question ID: ', maxQuestionID, ', Content Length: ', maxContentLength) AS Result;
    ELSE
        SELECT CONCAT('No ', questionType, ' question found') AS Result;
    END IF;
END //

DELIMITER ;
CALL FindLongestQuestion('Essay');

-- Cau 9: 
DELIMITER //

CREATE PROCEDURE DeleteExam(
    IN examIDToDelete INT
)
BEGIN
    DECLARE rowCount INT;

    -- Check if the exam exists
    SELECT COUNT(*) INTO rowCount
    FROM Exam
    WHERE ExamID = examIDToDelete;

    -- If the exam exists, delete it
    IF rowCount > 0 THEN
        DELETE FROM Exam WHERE ExamID = examIDToDelete;
        SELECT CONCAT('Exam with ID ', examIDToDelete, ' deleted successfully.') AS Result;
    ELSE
        SELECT CONCAT('Exam with ID ', examIDToDelete, ' does not exist.') AS Result;
    END IF;
END //

DELIMITER ;

CALL DeleteExam(15);
-- CAU 10: 
DELIMITER //

CREATE PROCEDURE DeleteExamsCreatedBefore3Years()
BEGIN
    DECLARE deleteCount INT;
    
    -- Delete exams created before 3 years
    DELETE FROM Exam
    WHERE YEAR(CreateDate) < YEAR(CURDATE()) - 3;
    
    -- Get the number of deleted exams
    SET deleteCount = ROW_COUNT();

    -- Delete related records from ExamQuestion table
    DELETE FROM ExamQuestion
    WHERE ExamID NOT IN (SELECT ExamID FROM Exam);

    -- Get the number of deleted records from ExamQuestion table
    SET deleteCount = deleteCount + ROW_COUNT();

    -- Print the total number of deleted records
    SELECT CONCAT('Total number of deleted records: ', deleteCount) AS Result;
END //

DELIMITER ;
CALL DeleteExamsCreatedBefore3Years();

-- Cau 11:
DELIMITER //

CREATE PROCEDURE DeleteDepartmentAndMoveAccounts(
    IN departmentNameToDelete NVARCHAR(30)
)
BEGIN
    DECLARE defaultDepartmentID INT;
    
    -- Find the default department ID
    SELECT DepartmentID INTO defaultDepartmentID
    FROM Department
    WHERE DepartmentName = 'Chờ việc';
    
    -- Update accounts belonging to the department to be deleted
    UPDATE Account
    SET DepartmentID = defaultDepartmentID
    WHERE DepartmentID = (SELECT DepartmentID FROM Department WHERE DepartmentName = departmentNameToDelete);
    
    -- Delete the department
    DELETE FROM Department
    WHERE DepartmentName = departmentNameToDelete;
    
    -- Get the number of affected rows (accounts moved and department deleted)
    SELECT ROW_COUNT() AS NumberOfAccountsMoved;
END //

DELIMITER ;

CALL DeleteDepartmentAndMoveAccounts('Thư ký');

-- CAU 12: Viết store để in ra mỗi tháng có bao nhiêu câu hỏi được tạo trong năm nay
DELIMITER //

CREATE PROCEDURE CountQuestionsCreatedPerMonth()
BEGIN
    DECLARE monthCursor INT;
    DECLARE questionCount INT;

    -- Create a temporary table to store the monthly question counts
    CREATE TEMPORARY TABLE IF NOT EXISTS MonthlyQuestionCounts (
        Month INT,
        QuestionCount INT
    );

    -- Iterate over each month of the current year
    SET monthCursor = 1;
    WHILE monthCursor <= 12 DO
        -- Count the number of questions created in the current month
        SELECT COUNT(*) INTO questionCount
        FROM Question
        WHERE YEAR(CreateDate) = YEAR(CURDATE()) AND MONTH(CreateDate) = monthCursor;

        -- Insert the month and its corresponding question count into the temporary table
        INSERT INTO MonthlyQuestionCounts (Month, QuestionCount) VALUES (monthCursor, questionCount);

        -- Increment the month cursor
        SET monthCursor = monthCursor + 1;
    END WHILE;

    -- Select and print the monthly question counts
    SELECT * FROM MonthlyQuestionCounts;

    -- Drop the temporary table
    DROP TEMPORARY TABLE IF EXISTS MonthlyQuestionCounts;
END //

DELIMITER ;
CALL CountQuestionsCreatedPerMonth();
-- cAU 13: 
DROP PROCEDURE IF EXISTS CountQuestionsPerMonthRecent6Months;


DELIMITER //

CREATE PROCEDURE CountQuestionsPerMonthRecent6Months()
BEGIN
    DECLARE monthCursor INT;
    DECLARE currentMonth INT;
    DECLARE questionCount INT;
    DECLARE startDate DATE;
    
    -- Set current month
    SET currentMonth = MONTH(CURDATE());
    
    -- Create a temporary table to store the monthly question counts
    CREATE TEMPORARY TABLE IF NOT EXISTS MonthlyQuestionCounts (
        Month INT,
        QuestionCount INT
    );
    
    -- Set start date to 6 months ago
    SET startDate = DATE_SUB(CURDATE(), INTERVAL 6 MONTH);
    
    -- Iterate over each month of the recent 6 months
    SET monthCursor = 0;
    WHILE monthCursor < 6 DO
        -- Calculate the month to query
        SET @queryMonth = MONTH(DATE_ADD(startDate, INTERVAL monthCursor MONTH));
        
        -- Count the number of questions created in the current month
        SELECT COUNT(*) INTO questionCount
        FROM Question
        WHERE YEAR(CreateDate) = YEAR(startDate)
            AND MONTH(CreateDate) = @queryMonth;
        
        -- Insert the month and its corresponding question count into the temporary table
        INSERT INTO MonthlyQuestionCounts (Month, QuestionCount) VALUES (@queryMonth, questionCount);
        
        -- Increment the month cursor
        SET monthCursor = monthCursor + 1;
    END WHILE;
    
    -- Select and print the monthly question counts
    SELECT
        CASE
            WHEN Month IS NULL THEN "Không có câu hỏi nào trong tháng"
            ELSE CONCAT("Tháng ", Month, ": ", IFNULL(QuestionCount, 0), " câu hỏi")
        END AS Result
    FROM (
        SELECT
            MONTH(CreateDate) AS Month,
            SUM(CASE WHEN MONTH(CreateDate) IS NOT NULL THEN QuestionCount ELSE 0 END) AS QuestionCount
        FROM (
            SELECT
                MONTH(CreateDate) AS Month,
                COUNT(*) AS QuestionCount
            FROM
                Question
            WHERE
                CreateDate >= startDate
            GROUP BY
                Month
            UNION
            SELECT
                NULL AS Month,
                NULL AS QuestionCount
            FROM
                Information_Schema.Columns
            LIMIT 6
        ) AS QuestionCounts
        GROUP BY
            Month
    ) AS MonthlyQuestionCounts;
    
    -- Drop the temporary table
    DROP TEMPORARY TABLE IF EXISTS MonthlyQuestionCounts;
END //

DELIMITER ;

CALL CountQuestionsPerMonthRecent6Months();

