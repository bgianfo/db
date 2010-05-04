DROP TABLE Student;
DROP TABLE Advisor; 
DROP TABLE Next_Of_Kin; 
DROP TABLE Has_Next_Of_Kin;
DROP TABLE Staff;
DROP TABLE Instructor;
DROP TABLE Course;
DROP TABLE HOR;
DROP TABLE Flat;
DROP TABLE Room;
DROP TABLE Invoice;
DROP TABLE Leases;
DROP TABLE Inspects;
DROP TABLE Takes;
DROP SEQUENCE lease_numbers;
DROP SEQUENCE invoice_numbers;

CREATE SEQUENCE lease_numbers START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE invoice_numbers START WITH 1 INCREMENT BY 1;

CREATE TABLE Advisor (
	email VARCHAR2(30) PRIMARY KEY,
	lastName VARCHAR2(20),
	firstName VARCHAR2(20),
	middleName VARCHAR2(20),
	position VARCHAR2(20),
	department VARCHAR2(20),
	extension VARCHAR2(6),
	room VARCHAR2(8)
);

CREATE TABLE Student (
	bannerNo VARCHAR2(12) PRIMARY KEY,
	lastName VARCHAR2(20),
	firstName VARCHAR2(20),
	middleName VARCHAR2(20),
	dob DATE,
	gender VARCHAR2(1),
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
	advisorEmail VARCHAR2(30),
	CONSTRAINT fk_advisor
		FOREIGN KEY (advisorEmail) 
		REFERENCES Advisor(email)
		ON DELETE RESTRICT
);

CREATE TABLE Next_Of_Kin (
	name VARCHAR2(50),
	contactTelNo VARCHAR2(12),
	city VARCHAR2(20),
	street VARCHAR2(25),
	postCode NUMBER(1,5),
	PRIMARY KEY (name, contactTelNo)
);

CREATE TABLE Has_Next_Of_Kin (
	name VARCHAR2(50),
	contactTelNo VARCHAR2(12),
	bannerNo VARCHAR2(12),
	relationship VARCHAR2(25),
	PRIMARY KEY (name, contactTelNo, bannerNo),
	CONSTRAINT fk_contact
		FOREIGN KEY (name, contactTelNo) 
		REFERENCES Next_Of_Kin(name, contactTelNo)
		ON DELETE CASCADE
	CONSTRAINT fk_student
		FOREIGN KEY (bannerNo) 
		REFERENCES Student(bannerNo)
		ON DELETE RESTRICT
);

CREATE TABLE Staff (
	staffNo VARCHAR2(12) PRIMARY KEY,
	lastName VARCHAR2(20),
	firstName VARCHAR2(20),
	dob DATE,
	street VARCHAR2(25),
	city VARCHAR2(20),
	postCode NUMBER(5,0),
	email VARCHAR2(50),
	position VARCHAR2(30),
	location VARCHAR2(30),
	gender VARCHAR2(1)
);

CREATE TABLE Instructor (
	lastName VARCHAR2(20),
	firstName VARCHAR2(20),
	middleName VARCHAR2(20),
	email VARCHAR2(50) PRIMARY KEY,
	campusTelNo VARCHAR2(12),
	dept VARCHAR2(12)
);

CREATE TABLE Course (
	courseNo VARCHAR2(20) PRIMARY KEY,
	courseTitle VARCHAR2(35),
	instructor VARCHAR2(50),
	CONSTRAINT fk_instructor
		FOREIGN KEY (instructor) 
		REFERENCES Instructor(email)
		ON DELETE RESTRICT
);

CREATE TABLE HOR (
	name VARCHAR2(20) PRIMARY KEY,
	addr VARCHAR2(50),
	telNo VARCHAR2(12),
	managedBy VARCHAR2(12)
	CONSTRAINT fk_managedBy
		FOREIGN KEY (managedBy) 
		REFERENCES Staff(email)
		ON DELETE RESTRICT
);

CREATE TABLE Flat (
	aptNo VARCHAR2(5) PRIMARY KEY,
	addr VARCHAR2(50)
);

CREATE TABLE Room (
	placeNo NUMBER(5,0) PRIMARY KEY,
	rentRate NUMBER(4,2),
	horName VARCHAR2(20) ,
	horRoomNo NUMBER(4,0),
	aptNo VARCHAR2(5),
	CONSTRAINT fk_hor
		FOREIGN KEY (horName) 
		REFERENCES HOR(name)
		ON DELETE CASCADE,
	CONSTRAINT fk_flat
		FOREIGN KEY (aptNo) 
		REFERENCES Flat(aptNo)
		ON DELETE CASCADE
);

CREATE TABLE Leases (
	leaseNo NUMBER PRIMARY KEY,
	bannerNo VARCHAR2(12),
	placeNo NUMBER,
	duration NUMBER,
	moveInDate DATE,
	moveOutDate DATE,
	CONSTRAINT fk_tenant
		FOREIGN KEY (bannerNo) 
		REFERENCES Student(bannerNo)
		ON DELETE CASCADE
	CONSTRAINT fk_room_rented
		FOREIGN KEY (placeNo) 
		REFERENCES Room(placeNo)
		ON DELETE RESTRICT
);

CREATE TABLE Invoice (
	invoiceNo NUMBER PRIMARY KEY,
	leaseNo NUMBER,
	semester NUMBER,
	paymentDue DATE
	CONSTRAINT fk_lease
		FOREIGN KEY (leaseNo) 
		REFERENCES Lease(leaseNo)
		ON DELETE CASCADE
);

CREATE TABLE Inspects (
	aptNo NUMBER,
	staffNo VARCHAR2(12),
	dateOfInspection NUMBER,
	result VARCHAR2(10),
	comments CLOB,
	PRIMARY KEY (aptNo, staffNo, dateOfInspection),
	CONSTRAINT fk_inspector
		FOREIGN KEY (staffNo) 
		REFERENCES Staff(staffNo)
		ON DELETE RESTRICT,
	CONSTRAINT fk_apt_inspected
		FOREIGN KEY (aptNo) 
		REFERENCES Flat(aptNo)
		ON DELETE CASCADE
);

CREATE TABLE Takes (
	bannerNo VARCHAR2(12),
	courseNo VARCHAR2(20),
	PRIMARY KEY (bannerNo, courseNo),
	CONSTRAINT fk_student_taking
		FOREIGN KEY (bannerNo) 
		REFERENCES Student(bannerNo)
		ON DELETE CASCADE
	CONSTRAINT fk_course_taken
		FOREIGN KEY (courseNo) 
		REFERENCES Course(courseNo)
		ON DELETE CASCADE
);

CREATE OR REPLACE TRIGGER lease_number_trigger 
BEFORE INSERT ON leases REFERENCING NEW AS NEW
FOR EACH ROW BEGIN
	SELECT lease_numbers.nextval INTO :NEW.leaseNo FROM dual;
END;
/

CREATE OR REPLACE TRIGGER invoice_number_trigger 
BEFORE INSERT ON invoice REFERENCING NEW AS NEW
FOR EACH ROW BEGIN
	SELECT invoice_numbers.nextval INTO :NEW.invoiceNo FROM dual;
END;
/