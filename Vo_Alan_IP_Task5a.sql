--SQL statements that implement all queries 1-14 with error checking
--Query 1: Insert a new visitor into the database and associate them with one or more park programs
DROP PROCEDURE IF EXISTS insert_visitor;
GO
CREATE PROCEDURE insert_visitor
    --input parameters for Person and Visitor tables
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
    @subscribed_to_newsletter CHAR(1)
AS
BEGIN
    --insert into Person table first (parent class of Visitor) 
    INSERT INTO Person
    VALUES
        (@person_ID, @first_name, @last_name, @middle_initial, @date_of_birth, @gender, @street, @city, @us_state, @postal_code, @subscribed_to_newsletter);
    --insert into Visitor table 
    INSERT INTO Visitor
    VALUES
        (@person_ID);
END
GO
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--stored procedure for associating Visitors with park programs
DROP PROCEDURE IF EXISTS enroll_visitors;
GO
CREATE PROCEDURE enroll_visitors
    --input parameters for Enroll_in table
    @person_ID INT, 
    @park_name VARCHAR(64), 
    @program_name VARCHAR(64), 
    @visit_date DATE, 
    @accessibility_needs VARCHAR(500)
AS
BEGIN
    --insert into Enroll_in table
    INSERT INTO Enroll_in
    VALUES
        (@person_ID, @park_name, @program_name, @visit_date, @accessibility_needs);
END
GO

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--stored procedure for associating Visitors with park passes (adding to Park_pass and Holds tables)
DROP PROCEDURE IF EXISTS visitor_passes;
GO
CREATE PROCEDURE visitor_passes
    --input parameters for Park_pass table
   @pass_ID INT, 
   @pass_type VARCHAR(20), 
   @expiration_date DATE,
   --input parameter for Holds table
   @person_ID INT
AS
BEGIN
    --insert into Park_pass table first (add new park pass to database)
    INSERT INTO Park_pass
    VALUES
        (@pass_ID, @pass_type, @expiration_date);
    --insert into Holds table (associate them with visitor)
    INSERT INTO Holds
    VALUES 
        (@pass_ID, @person_ID)
END
GO
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
    @ranger_status VARCHAR(10)
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
        (@person_ID, @team_ID, @ranger_start_date, @ranger_status);
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

--use stored procedures for phone numbers, emails, and emergency contacts from query 1 
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--Query 3. Insert a new ranger team into the database and set its leader(1/month).
--insert new ranger team into Ranger_team table

--set leader to an existing ranger (that is not assigned to a team yet)
--if ranger assigned to different team,  update team_ID in Assigned_to to point to new ranger team 

--then create 
-- INSERT INTO Ranger_team
-- VALUES 
-- (9, 'Preservation of wildlife', '2023-10-10');

-- INSERT INTO Assigned_to
-- VALUES 
-- (3, 9, '2023-12-12', 'active', 'leader');

-----------------------------------------------------------------------------------------------
--Query 4. Insert a new donation from a donor (5/day). 
--would also use stored procedures from query 1 for adding emails, phone numbers, and emergency contacts 
--stored procedure for inserting donor into Person and Donor tables
DROP PROCEDURE IF EXISTS insert_donor;
GO
CREATE PROCEDURE insert_donor
    --input parameters for Person tables
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
    --input parameter for Donor
    @anonymity_preference CHAR(1)
AS
BEGIN
    --insert into Person table first (parent class of Donor) 
    INSERT INTO Person
    VALUES
        (@person_ID, @first_name, @last_name, @middle_initial, @date_of_birth, @gender, @street, @city, @us_state, @postal_code, @subscribed_to_newsletter);
    --insert into Donor table 
    INSERT INTO Donor
    VALUES
        (@person_ID, @anonymity_preference);
END
GO
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--stored procedure for inserting into Check_donation table
DROP PROCEDURE IF EXISTS insert_check_donation;
GO
CREATE PROCEDURE insert_check_donation
    --input parameters for Person tables
    @person_ID INT,
    @donation_date DATE, 
    @amount NUMERIC(8,2),
    @campaign_name VARCHAR(64), 
    @check_number VARCHAR(20)
AS
BEGIN
    --insert into Check_donation table
    INSERT INTO Check_donation
    VALUES
        (@person_ID, @donation_date, @amount, @campaign_name, @check_number);
END
GO
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--stored procedure for inserting into Credit_card_donation table
DROP PROCEDURE IF EXISTS insert_credit_card_donation;
GO
CREATE PROCEDURE insert_credit_card_donation
    --input parameters for Person tables
    @person_ID INT,
    @donation_date DATE, 
    @amount NUMERIC(8,2),
    @campaign_name VARCHAR(64), 
    @card_type VARCHAR(64), 
    @last_four_digits CHAR(4), 
    @expiration_date DATE
AS
BEGIN
    --insert into Check_donation table
    INSERT INTO Credit_card_donation
    VALUES
        (@person_ID, @donation_date, @amount, @campaign_name, @card_type, @last_four_digits, @expiration_date);
END
GO



--5. Insert a new researcher into the database and associate them with one or more ranger teams (1/year).
--stored procedure for inserting new researcher into Person and Researcher tables
DROP PROCEDURE IF EXISTS insert_researcher;
GO
CREATE PROCEDURE insert_researcher
    --input parameters for Person tables
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
    --input parameters for researchers
    @research_field VARCHAR(40),
    @hire_date DATE, 
    @salary NUMERIC(8,2)
AS
BEGIN
    --insert into Person table first (parent class of Researcher) 
    INSERT INTO Person
    VALUES
        (@person_ID, @first_name, @last_name, @middle_initial, @date_of_birth, @gender, @street, @city, @us_state, @postal_code, @subscribed_to_newsletter);
    --insert into Donor table 
    INSERT INTO Researcher
    VALUES
        (@person_ID, @research_field, @hire_date, @salary);
END
GO
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
--stored procedure for associating researcher with ranger teams
DROP PROCEDURE IF EXISTS query_5;
GO
CREATE PROCEDURE query_5
    --only insert team_ID and person_ID (reports added later in query 6)
    @team_ID INT, 
    @person_ID INT
AS
BEGIN
    --insert into Reports_to table to associate researcher with ranger team (NULL values for report date and summary because we are updating them in query 6)
    INSERT INTO Reports_to
    VALUES
        (@team_ID, @person_ID, NULL, NULL);
END
GO
--account for multiple phone numbers, emails, and emergency contacts using stored procedures from query 1 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--6.Insert a report submitted by a ranger team to a researcher
--stored procedure for updating report_date and activities_summary columns for tuple in Reports_to table with given team_ID and researcher id
DROP PROCEDURE IF EXISTS add_report;
GO
CREATE PROCEDURE add_report
    --need team_ID and person_ID to get correct tuple that associates specific ranger team with one researcher 
    @team_ID INT, 
    @person_ID INT,
    --using the above input parameters, update the report_date and activities_summary columns for the corresponding tuple 
    @report_date DATE, 
    @activities_summary VARCHAR(1024)
AS
BEGIN
    --use update statement (for certain ranger team and researcher combo) 
    UPDATE Reports_to
    SET report_date = @report_date, activities_summary = @activities_summary
    WHERE Reports_to.team_ID = @team_ID AND Reports_to.person_ID = @person_ID;
END
GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------
--7. Insert a new park program into the database for a specific park (2/month).
--stored procedure for adding national park to database if it doesn't exist yet. 
DROP PROCEDURE IF EXISTS add_national_park;
GO
CREATE PROCEDURE add_national_park
    --input parameters for National_park table
    @park_name VARCHAR(64), 
    @street VARCHAR(64), 
    @city VARCHAR(30), 
    @us_state CHAR(2), 
    @postal_code VARCHAR(10), 
    @establishment_date DATE, 
    @visitor_capacity INT
AS
BEGIN
    --insert into National_park table
    INSERT INTO National_park
    VALUES
        (@park_name, @street, @city, @us_state, @postal_code, @establishment_date, @visitor_capacity);
END
GO
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
--stored procedure for adding park programs to an existing national park 
DROP PROCEDURE IF EXISTS add_program;
GO
CREATE PROCEDURE add_program
    --input parameters for Program table
    @park_name VARCHAR(64), 
    @program_name VARCHAR(64), 
    @program_type VARCHAR (64), 
    @program_start_date DATE, 
    @duration INT
AS
BEGIN
    --insert into Program table
    INSERT INTO Program
    VALUES
        (@park_name, @program_name, @program_type, @program_start_date, @duration);
END
GO


---------------------------------------------------------------------------------------------------------------------------------------------------------------------
--8. Retrieve the names and contact information of all emergency contacts for a specific person
DROP PROCEDURE IF EXISTS retrieve_emergency_contacts;
GO
CREATE PROCEDURE retrieve_emergency_contacts
    --input parameter person_ID for person we want to retrieve emergency contacts for
    @person_ID INT
AS
BEGIN
SELECT contact_name, relationship, phone_number
FROM Emergency_contact
WHERE Emergency_contact.person_ID = @person_ID;
END
GO
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
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


