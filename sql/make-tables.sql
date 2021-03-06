DROP TABLE Student CASCADE CONSTRAINTS PURGE;
DROP TABLE Advisor CASCADE CONSTRAINTS  PURGE; 
DROP TABLE Next_Of_Kin CASCADE CONSTRAINTS  PURGE; 
DROP TABLE Has_Next_Of_Kin CASCADE CONSTRAINTS  PURGE;
DROP TABLE Staff CASCADE CONSTRAINTS  PURGE;
DROP TABLE Instructor CASCADE CONSTRAINTS  PURGE;
DROP TABLE Course CASCADE CONSTRAINTS  PURGE;
DROP TABLE HOR CASCADE CONSTRAINTS  PURGE;
DROP TABLE Flat CASCADE CONSTRAINTS  PURGE;
DROP TABLE Room CASCADE CONSTRAINTS  PURGE;
DROP TABLE Invoice CASCADE CONSTRAINTS  PURGE;
DROP TABLE Leases CASCADE CONSTRAINTS  PURGE;
DROP TABLE Inspects CASCADE CONSTRAINTS  PURGE;
DROP TABLE Takes CASCADE CONSTRAINTS  PURGE;
DROP SEQUENCE lease_numbers;
DROP SEQUENCE invoice_numbers;

CREATE SEQUENCE lease_numbers START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE invoice_numbers START WITH 1 INCREMENT BY 1;

CREATE TABLE Advisor (
	email VARCHAR2(30) NOT NULL PRIMARY KEY,
	lastName VARCHAR2(20) NOT NULL,
	firstName VARCHAR2(20),
	middleName VARCHAR2(20),
	position VARCHAR2(20),
	department VARCHAR2(20),
	extension VARCHAR2(6),
	room VARCHAR2(8)
);

CREATE TABLE Student (
	bannerNo VARCHAR2(12) NOT NULL PRIMARY KEY,
	lastName VARCHAR2(20) NOT NULL ,
	firstName VARCHAR2(20) NOT NULL ,
	middleName VARCHAR2(20) NOT NULL,
	dob DATE,
	gender VARCHAR2(1),
	street VARCHAR2(25),
	city VARCHAR2(20),
	postCode NUMBER(5,0),
	email VARCHAR2(30),
	mobilePhone VARCHAR2(12),
	major VARCHAR2(50),
	minor VARCHAR2(50),
	category VARCHAR2(20) NOT NULL,
	nationality VARCHAR2(20),
	specialNeeds CLOB, 
	comments CLOB,
	advisorEmail VARCHAR2(30) NOT NULL,
	CONSTRAINT fk_advisor
		FOREIGN KEY (advisorEmail) 
		REFERENCES Advisor(email),
	CONSTRAINT check_student_gender
		CHECK (gender IS NULL OR gender IN ('M', 'F') ),
	CONSTRAINT check_student_category
		CHECK (category IN ('Firstyear', 'Undergrad', 'Grad', 'Postgrad') )
);

CREATE TABLE Next_Of_Kin (
	name VARCHAR2(50) NOT NULL,
	contactTelNo VARCHAR2(12) NOT NULL,
	city VARCHAR2(20),
	street VARCHAR2(25),
	postCode NUMBER(5,0),
	PRIMARY KEY (name, contactTelNo)
);

CREATE TABLE Has_Next_Of_Kin (
	name VARCHAR2(50) NOT NULL ,
	contactTelNo VARCHAR2(12) NOT NULL ,
	bannerNo VARCHAR2(12) NOT NULL ,
	relationship VARCHAR2(25) NOT NULL,
	PRIMARY KEY (name, contactTelNo, bannerNo),
	CONSTRAINT fk_contact
		FOREIGN KEY (name, contactTelNo) 
		REFERENCES Next_Of_Kin(name, contactTelNo)
		ON DELETE CASCADE,
	CONSTRAINT fk_student
		FOREIGN KEY (bannerNo) 
		REFERENCES Student(bannerNo)
		ON DELETE CASCADE
);

CREATE TABLE Staff (
	staffNo VARCHAR2(12) NOT NULL PRIMARY KEY,
	lastName VARCHAR2(20) NOT NULL,
	firstName VARCHAR2(20) NOT NULL,
	dob DATE,
	street VARCHAR2(25),
	city VARCHAR2(20),
	postCode NUMBER(5,0),
	email VARCHAR2(50),
	position VARCHAR2(30),
	location VARCHAR2(30),
	gender VARCHAR2(1),
	CONSTRAINT check_staff_gender
		CHECK (gender IS NULL OR gender IN ('M', 'F') )
);

CREATE TABLE Instructor (
	lastName VARCHAR2(20) NOT NULL,
	firstName VARCHAR2(20),
	middleName VARCHAR2(20),
	email VARCHAR2(50) NOT NULL PRIMARY KEY,
	campusTelNo VARCHAR2(12),
	dept VARCHAR2(12)
);

CREATE TABLE Course (
	courseNo VARCHAR2(20) NOT NULL PRIMARY KEY,
	courseTitle VARCHAR2(35) NOT NULL,
	instructor VARCHAR2(50) NOT NULL,
	CONSTRAINT fk_instructor
		FOREIGN KEY (instructor) 
		REFERENCES Instructor(email)
);

CREATE TABLE HOR (
	name VARCHAR2(20) NOT NULL PRIMARY KEY,
	addr VARCHAR2(50) NOT NULL,
	telNo VARCHAR2(12),
	managedBy VARCHAR2(12) NOT NULL,
	CONSTRAINT fk_managedBy
		FOREIGN KEY (managedBy) 
		REFERENCES Staff(staffNo)
);

CREATE TABLE Flat (
	aptNo VARCHAR2(5) NOT NULL PRIMARY KEY,
	addr VARCHAR2(50) NOT NULL
);

CREATE TABLE Room (
	placeNo NUMBER(5,0) NOT NULL PRIMARY KEY,
	rentRate NUMBER(6,2) NOT NULL,
	horName VARCHAR2(20),
	horRoomNo NUMBER(4,0),
	aptNo VARCHAR2(5),
	CONSTRAINT fk_hor
		FOREIGN KEY (horName) 
		REFERENCES HOR(name)
		ON DELETE CASCADE,
	CONSTRAINT fk_flat
		FOREIGN KEY (aptNo) 
		REFERENCES Flat(aptNo)
		ON DELETE CASCADE,
	CONSTRAINT must_be_room_xor_flat
		CHECK ( 
			(horName IS NULL AND horRoomNo IS NULL AND aptNo IS NOT NULL) OR 
			(horName IS NOT NULL AND horRoomNo IS NOT NULL AND aptNo IS NULL) 
		)
);

CREATE TABLE Leases (
	leaseNo NUMBER NOT NULL PRIMARY KEY,
	bannerNo VARCHAR2(12) NOT NULL,
	placeNo NUMBER NOT NULL,
	duration NUMBER NOT NULL,
	moveInDate DATE NOT NULL,
	moveOutDate DATE,
	CONSTRAINT fk_tenant
		FOREIGN KEY (bannerNo) 
		REFERENCES Student(bannerNo)
		ON DELETE CASCADE,
	CONSTRAINT fk_room_rented
		FOREIGN KEY (placeNo) 
		REFERENCES Room(placeNo)
);

CREATE TABLE Invoice (
	invoiceNo NUMBER NOT NULL PRIMARY KEY,
	leaseNo NUMBER NOT NULL,
	semester NUMBER NOT NULL,
	paymentDue DATE NOT NULL,
	CONSTRAINT fk_lease
		FOREIGN KEY (leaseNo) 
		REFERENCES Leases(leaseNo)
		ON DELETE CASCADE
);

CREATE TABLE Inspects (
	aptNo VARCHAR2(5) NOT NULL,
	staffNo VARCHAR2(12) NOT NULL,
	dateOfInspection DATE NOT NULL,
	result VARCHAR2(10) NOT NULL,
	comments CLOB,
	PRIMARY KEY (aptNo, staffNo, dateOfInspection),
	CONSTRAINT fk_inspector
		FOREIGN KEY (staffNo) 
		REFERENCES Staff(staffNo),
	CONSTRAINT fk_apt_inspected
		FOREIGN KEY (aptNo) 
		REFERENCES Flat(aptNo)
		ON DELETE CASCADE
);

CREATE TABLE Takes (
	bannerNo VARCHAR2(12) NOT NULL,
	courseNo VARCHAR2(20) NOT NULL,
	PRIMARY KEY (bannerNo, courseNo),
	CONSTRAINT fk_student_taking
		FOREIGN KEY (bannerNo) 
		REFERENCES Student(bannerNo)
		ON DELETE CASCADE,
	CONSTRAINT fk_course_taken
		FOREIGN KEY (courseNo) 
		REFERENCES Course(courseNo)
		ON DELETE CASCADE
);

CREATE OR REPLACE TRIGGER lease_number_trigger 
BEFORE INSERT ON leases REFERENCING NEW AS NEW
FOR EACH ROW WHEN (NEW.leaseNo IS NULL)
	BEGIN
		SELECT lease_numbers.nextval INTO :NEW.leaseNo FROM dual;
	END;
/

CREATE OR REPLACE TRIGGER invoice_number_trigger 
BEFORE INSERT ON invoice REFERENCING NEW AS NEW
	FOR EACH ROW WHEN (NEW.invoiceNo IS NULL)
	BEGIN
		SELECT invoice_numbers.nextval INTO :NEW.invoiceNo FROM dual;
	END;
/

exit