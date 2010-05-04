DROP TABLE Student;
DROP TABLE Advisor; 
DROP TABLE NextOfKin; 

CREATE TABLE Student (
	bannerNo VARCHAR2(12) PRIMARY KEY,
	lastName VARCHAR2(20),
	firstName VARCHAR2(20),
	middleName VARCHAR2(20),
	dob DATE,
	street VARCHAR2(25),
	city VARCHAR2(20),
	postCode NUMBER(5,0),
	email VARCHAR2(30),
	mobilePhone VARCHAR2(12),
	major VARCHAR2(50),
	minor VARCHAR2(50),
	category VARCHAR2(20),
	nationality VARCHAR2(20),
	specialNeeds CLOB, 
	comments CLOB,
	advisorEmail VARCHAR2(30)
);

CREATE TABLE Advisor (
	email VARCHAR2(30) PRIMARY KEY,
	lastName VARCHAR2(20),
	firstName VARCHAR2(20),
	middleName VARCHAR2(20),
	position VARCHAR2(20),
	department VARCHAR2(20),
	extension VARCHAR2(6,0),
	room VARCHAR2(8)
);

CREATE TABLE Next_Of_Kin (
	name VARCHAR2(50) PRIMARY KEY,
	contactTelNo VARCHAR2(12) PRIMARY KEY,
	city VARCHAR2(20),
	street VARCHAR2(25),
	postCode NUMBER(1,5)
);

CREATE TABLE Has_Next_Of_Kin (
	name VARCHAR2(50) PRIMARY KEY,
	contactTelNo VARCHAR2(12) PRIMARY KEY,
	bannerNo VARCHAR2(12) PRIMARY KEY,
	relationship VARCHAR2(25)
);