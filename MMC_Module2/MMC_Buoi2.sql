CREATE DATABASE IF NOT EXISTS hr;
USE hr;

DROP TABLE IF EXISTS EMPLOYEES;
CREATE TABLE EMPLOYEES (
                            EMP_ID CHAR(9) NOT NULL, 
                            F_NAME VARCHAR(15) NOT NULL,
                            L_NAME VARCHAR(15) NOT NULL,
                            SSN CHAR(9),
                            B_DATE DATE,
                            SEX CHAR,
                            ADDRESS VARCHAR(30),
                            JOB_ID CHAR(9),
                            SALARY DECIMAL(10,2),
                            MANAGER_ID CHAR(9),
                            DEP_ID CHAR(9) NOT NULL,
                            PRIMARY KEY (EMP_ID));

DROP TABLE IF EXISTS JOB_HISTORY;
CREATE TABLE JOB_HISTORY (
                            EMPL_ID CHAR(9) NOT NULL, 
                            START_DATE DATE,
                            JOBS_ID CHAR(9) NOT NULL,
                            DEPT_ID CHAR(9),
                            PRIMARY KEY (EMPL_ID,JOBS_ID));
                            
DROP TABLE IF EXISTS JOBS;
CREATE TABLE JOBS (
                            JOB_IDENT CHAR(9) NOT NULL, 
                            JOB_TITLE VARCHAR(50) ,
                            MIN_SALARY DECIMAL(10,2),
                            MAX_SALARY DECIMAL(10,2),
                            PRIMARY KEY (JOB_IDENT));

DROP TABLE IF EXISTS DEPARTMENTS;
CREATE TABLE DEPARTMENTS (
                            DEPT_ID_DEP CHAR(9) NOT NULL, 
                            DEP_NAME VARCHAR(50) ,
                            MANAGER_ID CHAR(9),
                            LOC_ID CHAR(9),
                            PRIMARY KEY (DEPT_ID_DEP));

drop table `DEPARTMENTS`

DROP TABLE IF EXISTS LOCATIONS;
CREATE TABLE LOCATIONS (
                            LOCT_ID CHAR(9) NOT NULL,
                            DEP_ID_LOC CHAR(9) NOT NULL,
                            PRIMARY KEY (LOCT_ID,DEP_ID_LOC));

INSERT INTO `EMPLOYEES`(EMP_ID,F_NAME,L_NAME,SSN,B_DATE,SEX,ADDRESS,JOB_ID,SALARY,MANAGER_ID,DEP_ID)
VALUES ('E1001','John', 'Thomas', 123456, '1976-01-09', 'M', '5631 Pice, Oak Park, JL', 100,100000,30001,2),
('E1002', 'Alice', 'James',123457,'1972-07-31','F', '980 Berry In,Elgin,JL', 200,80000,30002,5),
('E1003','Steve', 'Wells', 123458,'1980-08-10','M','291 Springs,Gary,JL',300,50000,30002,5);


select * from EMPLOYEES

INSERT INTO `JOB_HISTORY` (EMPL_ID,START_DATE,JOBS_ID,DEPT_ID)
VALUES('E1001', '2000-01-30',100,2),
('E1002','2010-08-16',200,5),
('E1003','2016-08-10',300,5);

INSERT INTO `JOBS` (JOB_IDENT, JOB_TITLE, MIN_SALARY,MAX_SALARY)
VALUES(100,'Sr.Achitect',60000,100000),
    (200,'Sr.SoftwareDeveloper',60000,80000),
    (300,'Jr.SoftwareDeveloper',40000,60000);


INSERT INTO `DEPARTMENTS` (DEPT_ID_DEP, DEP_NAME , MANAGER_ID, LOC_ID)
VALUES 
    (2 , 'Architect Group', 30001, 'L0001'),
    (5 , 'Software Development', 30002, 'L0002'), 
    (7, 'Design Team', 30003,'L0003'),
    (8, 'Software', 30004, 'L0004');

INSERT INTO `LOCATIONS` (LOCT_ID, DEP_ID_LOC)
VALUES 
        ('LOOO1', 2),
        ('LOOO2', 5),
        ('LOOO3', 7);