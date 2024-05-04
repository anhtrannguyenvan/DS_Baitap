CREATE DATABASE Testing_System_Db;
USE Testing_System_Db;

--Create table Department--
CREATE TABLE Department(
    DepartmentId INT AUTO_INCREMENT PRIMARY KEY,
    DepartmentName VARCHAR(50)
);
-- Create table Position--
CREATE TABLE Positions(
    PositionId INT AUTO_INCREMENT PRIMARY KEY,
    PositionName VARCHAR(255)
);
--Create table Account--
CREATE TABLE Accounts(
    AccountID INT AUTO_INCREMENT PRIMARY KEY,
    Email VARCHAR(255),
    Username VARCHAR(255), 
    FullName VARCHAR(255),
    DepartmentId INT,
    PositionId INT,
    CreateDate DATE
);
--Create table Group
CREATE TABLE Group_Table(
    GroupID INT AUTO_INCREMENT PRIMARY KEY,
    GroupName VARCHAR(255),
    CreatorID INT,
    CreateDate DATE
);
--Create Table GroupAccount
CREATE TABLE Group_Acount(
    GroupID INT,
    AccountID INT,
    JoinDate DATE
)
--Create table TypeQuestion--

CREATE TABLE Type_Question(
    TypeID INT,
    TypeName VARCHAR(50)
);
--Create table CategoryQuestion--
CREATE TABLE category_question_table(
    CategoryID INT AUTO_INCREMENT,
    CategoryName VARCHAR(255)
);
--Create Table Question--
CREATE TABLE table_of_quest(
    QuestionID INT AUTO_INCREMENT PRIMARY KEY,
    content TEXT,
    CategoryID INT,
    TypeID INT,
    CreatorID INT,
    CreateDate DATE
);
--Create table answer--
CREATE TABLE ans_table(
    AnswerID INT AUTO_INCREMENT PRIMARY KEY,
    content TEXT,
    QuestionID INT,
    isCorrect BOOLEAN
);
--create table exam--
CREATE TABLE table_exam(
    ExamID INT AUTO_INCREMENT PRIMARY KEY,
    Code VARCHAR(50),
    Title VARCHAR(255),
    CategoryID INT,
    Duration INT,
    CreatorID INT,
    CreateDate DATE
);