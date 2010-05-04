DROP TABLE Student;
DROP TABLE Advisor; 
DROP TABLE NextOfKin; 

CREATE TABLE Student (
	bannerNo VARCHAR2(20) PRIMARY KEY,
	lastName VARCHAR(30),
	firstName VARCHAR(30),
	middleName VARCHAR(30),
	dob DATE,
	street VARCHAR2(25),
	city VARCHAR2(20),
	postCode NUMBER(1,5),
	email VARCHAR2(30),
	mobilePhone VARCHAR2(12),
	major VARCHAR2(50),
	minor VARCHAR2(50),
	category VARCHAR2(20),
	nationality VARCHAR2(20),
	specialNeeds CLOB, 
	comments CLOB
);


CREATE TABLE Advisor (
	email VARCHAR2(20) PRIMARY KEY,
	name VARCHAR2(50),
	position VARCHAR2(20),
	department VARCHAR2(20),
	extension VARCHAR2(4),
	room VARCHAR2(8)
);


CREATE TABLE NextOfKin (
	name VARCHAR2(50) PRIMARY KEY,
	relationship VARCHAR2(50),
	city VARCHAR2(20),
	street VARCHAR2(25),
	postCode NUMBER(1,5),
	contactTelNo VARCHAR2(12)
);
	
