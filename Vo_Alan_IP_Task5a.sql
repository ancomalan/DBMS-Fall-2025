--SQL statements that implement all queries 1-14 with error checking

--populate some data in National Park (assume that national parks already exist) for query 1
INSERT INTO National_park (park_name, street, city, us_state, postal_code, establishment_date, visitor_capacity)
VALUES 
('Yellowstone', '1 Grand Loop Rd', 'Yellowstone', 'WY', '82190', '1872-03-01', 25000),
('Yosemite', '9011 Village Dr', 'Yosemite Valley', 'CA', '95389', '1890-10-01', 20000),




-- ----------------------------------------------------------------------------------------------------------------------------------------------------
--Query 1: Insert a new visitor into the database and associate them with one or more park programs (10/day).
-- using PreparedStatement in java, the ? are placeholders that are replaced with user input during java execution
-- Insert into Person table first
INSERT INTO Person (
    person_ID, first_name, last_name, middle_initial, date_of_birth, gender,
    street, city, us_state, postal_code, subscription_status
) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);

--then insert into visitor table
INSERT INTO Visitor (
    person_ID
) VALUES (?);

-- assuming that national parks and programs already exist, add to Enroll_in table to associate visitors with park programs
--in java program, will have to use for loop to account for more than one park program
INSERT INTO Enroll_in (
    person_ID, park_name, program_name, visit_date, accessibility_needs
) VALUES (?, ?, ?, ?, ?);

--account for visitors having park passes by inserting into Parks_pass and Holds
INSERT INTO Park_pass (
    pass_ID, pass_type, expiration_date
) VALUES (?, ?, ?);

INSERT INTO Holds (
    pass_ID, person_ID
) VALUES (?, ?);

--account for multivalued attribute phone number
INSERT INTO Person_phone (
    person_ID, phone_number
) VALUES (?, ?);

-- account for multivalued attribuite email
INSERT INTO Person_email (
    person_ID, email
) VALUES (?, ?);

--person can have emergency contacts
INSERT INTO Emergency_contact (
    person_ID, contact_name, relationship, phone_number
) VALUES (?, ?, ?, ?);

-------------------------------------------------------------------------------------------------------------------------------------------------
--Query 2: Insert a new ranger into the database and assign them to a ranger team (2/month).
--stored procedure for inserting ranger into Person table, Ranger table, and Assigned_to table 
DROP PROCEDURE IF EXISTS query_2;
GO
CREATE PROCEDURE query_2
    --input parameters for Person and Ranger tables
    @person_ID INT,
    @first_name VARCHAR(64),
    @last_name VARCHAR(64),
    @middle_initial CHAR(1),
    @date_of_birth DATE,
    @gender CHAR(1),
    @street VARCHAR(100),
    @city VARCHAR(30),
    @us_state CHAR(2),
    @postal_code VARCHAR(10),
    @subscribed_to_newsletter CHAR(1),
    --input parameters for Assigned_to table
    @team_ID INT,
    @ranger_start_date DATE,
    @ranger_status VARCHAR(10),
    @ranger_role VARCHAR(10)
AS
BEGIN
    --insert into Person table first (parent class of Ranger) 
    INSERT INTO Person
    VALUES
        (@person_ID, @first_name, @last_name, @middle_initial, @date_of_birth, @gender, @street, @city, @us_state, @postal_code, @subscribed_to_newsletter);
    --insert into Ranger table 
    INSERT INTO Ranger
    VALUES
        (@person_ID);
    --insert into Assigned_to table to assign ranger to ranger team 
    INSERT INTO Assigned_to
    VALUES
        (@person_ID, @team_ID, @ranger_start_date, @ranger_status, @ranger_role);
END
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--stored procedure for rangers having certifications 
DROP PROCEDURE IF EXISTS add_ranger_certification;
GO
CREATE PROCEDURE add_ranger_certification
    --input parameters entered from the user in java
    @person_ID INT, 
    @certification VARCHAR(20)
AS
BEGIN
    --insert Ranger_certification table 
    INSERT INTO Ranger_certification
    VALUES
        (@person_ID, @certification);
END
GO
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--stored procedure accounting for all people (Rangers, Visitors, Researchers, Donors) possibly having multiple phone numbers)
DROP PROCEDURE IF EXISTS add_phone;
GO
CREATE PROCEDURE add_phone
    --input parameters entered from the user in java
    @person_ID INT, 
    @phone_number VARCHAR(20)
AS
BEGIN
    --insert into Person_phone table
    INSERT INTO Person_phone
    VALUES
        (@person_ID, @phone_number);
END
GO
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--stored procedure accounting for all people (Rangers, Visitors, Researchers, Donors) possibly having multiple emails)
DROP PROCEDURE IF EXISTS add_email;
GO
CREATE PROCEDURE add_email
    --input parameters entered from the user in java
    @person_ID INT, 
    @email_address VARCHAR(50)
AS
BEGIN
    --insert into Person_email table
    INSERT INTO Person_email
    VALUES
        (@person_ID, @email_address);
END
GO
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--stored procedure accounting for all people (Rangers, Visitors, Researchers, Donors) possibly having emergency contacts)
DROP PROCEDURE IF EXISTS add_emergency_contact;
GO
CREATE PROCEDURE add_emergency_contact
    --input parameters entered from the user in java
    @person_ID INT, 
    @contact_name VARCHAR (50), 
    @relationship VARCHAR (20), 
    @phone_number VARCHAR (20)
AS
BEGIN
    --insert into Emergency_contact table
    INSERT INTO Emergency_contact 
    VALUES
        (@person_ID, @contact_name, @relationship, @phone_number);
END
GO



------------------------------------------------------------------------------------------------------------
--Query 3. Insert a new ranger team into the database and set its leader(1/month).
--insert new ranger team into Ranger_team table

--set leader to an existing ranger (that is not assigned to a team yet)
--if ranger assigned to different team,  update team_ID in Assigned_to to point to new ranger team 

--then create 
INSERT INTO Ranger_team
VALUES 
(9, 'Preservation of wildlife', '2023-10-10');

INSERT INTO Assigned_to
VALUES 
(3, 9, '2023-12-12', 'active', 'leader');

-----------------------------------------------------------------------------------------------
--Query 4. Insert a new donation from a donor (5/day). 
--assume that the donor is already existing
INSERT INTO Check_donation 
VALUES (4, '2025-12-12', 100000, 'blackpink rules', 12);








--5. Insert a new researcher into the database and associate them with one or more ranger teams (1/year).














--13. Retrieve the names, IDs, contact information, and newsletter subscription status of all individuals in the database (1/week)
--have three seperate select statements
--first, display first name, middle initial, last name, ID, and newsletter subscription status from Person table  
SELECT person_ID, first_name, last_name, middle_initial, subscribed_to_newsletter
FROM Person

--get contact information (phone numbers and email addresses)
SELECT * 
FROM Person_phone 

SELECT * 
FROM Person_email


