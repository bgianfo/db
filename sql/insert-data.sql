INSERT into Advisor (email, lastName) values ('bob@t.edu', 'Pandaman');

insert into student (bannerNo, lastName, firstName, middleName, DOB, street, city, postCode, email, mobilePhone, major, minor, category, nationality, specialNeeds, comments, advisorEmail ) values ( 
'A0001', 'Smith', 'John', 'Q', to_date('1990-01-01', 'yyyy-mm-dd'), '1 Test Dr.', 'Testville', 12345, 'test@drive.com', '012-345-6789', 'Computer Science', 'Database Design', 'Undergrad', 'US', '', '', 'bob@t.edu');

insert into student (bannerNo, lastName, firstName, middleName, DOB, street, city, postCode, email, mobilePhone, major, minor, category, nationality, specialNeeds, comments, advisorEmail ) values ( 
'A0002', 'Buts', 'Seemore', 'B', to_date('1999-01-01', 'yyyy-mm-dd'), '2 Test Dr.', 'Lame Town', 78910, 'me@tosexy.com', '013-345-6789', 'Physics', 'Quantum', 'Undergrad', 'US', 'ADD', 'Cool Kid', 'bob@t.edu');

insert into student (bannerNo, lastName, firstName, middleName, DOB, street, city, postCode, email, mobilePhone, major, minor, category, nationality, specialNeeds, comments, advisorEmail ) values ( 
'A0003', 'Decapreo', 'Leanardo', 'A', to_date('1980-01-01', 'yyyy-mm-dd'), '5 Test Dr.', 'Hollywood', 88910, 'jack@titanic.com', '014-345-6789', 'Acting', 'Titanic set creation', 'Undergrad', 'US', '', '', 'bob@t.edu');

insert into student (bannerNo, lastName, firstName, middleName, DOB, street, city, postCode, email, mobilePhone, major, minor, category, nationality, specialNeeds, comments, advisorEmail ) values ( 
'A0004', 'Hawkings', 'Stephen', 'D', to_date('1970-01-01', 'yyyy-mm-dd'), 'Galaxy Way.', 'Cambridge', 18910, 'fancy@physics.com', '014-345-6789', 'Physics', 'Cosmology', 'Postgrad', 'UK', '', '', 'bob@t.edu');

INSERT INTO Staff ( staffNo, lastName, firstName ) VALUES ( '5', 'Bruce', 'Springstein' );
Insert INTO Flat ( aptNo, addr ) values ( '00001', '100 Road Way' );


INSERT INTO Room (placeNo, rentRate, aptNo) VALUES ( 1, 500.00, '00001' );


INSERT INTO HOR (name, addr, managedBy ) VALUES ( 'Jamision', '123 Ave', '5');

INSERT INTO Room (placeNo, rentRate, horName, horRoomNo) VALUES ( 2, 500.00, 'Jamision', 1  );

INSERT INTO Room (placeNo, rentRate, horName, horRoomNo) VALUES ( 3, 200.00, 'Jamision', 2  );

INSERT INTO Room (placeNo, rentRate, horName, horRoomNo) VALUES ( 4, 666.00, 'Jamision', 3  );



INSERT INTO Inspects ( aptNo, staffNo, dateOfInspection, result ) values ( '00001' , '5', to_date('1970-01-01', 'yyyy-mm-dd'), 'fail');

INSERT INTO Leases( leaseNo, bannerNo, placeNo, duration, moveInDate ) values ( 1, 'A0004', 1, 12, to_date('1989-01-01', 'yyyy-mm-dd') );
