--SQL statements that implement all queries 1-14 with error checking
--Query 1: Insert a new visitor into the database and associate them with one or more park programs
--stored procedure for inserting into Person and Visitor tables
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
--stored procedure for associating Visitors with park programs (assuming that park programs already exist)
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
--stored procedure accounting for all people (Rangers, Visitors, Researchers, Donors) possibly having multiple phone numbers
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
--stored procedure accounting for all people (Rangers, Visitors, Researchers, Donors) possibly having multiple emails
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
--stored procedure accounting for all people (Rangers, Visitors, Researchers, Donors) possibly having emergency contacts
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
--insert new ranger team into Ranger_team table using stored procedure 
--stored procedure for adding ranger team to the database (inserting into Ranger_team table)
DROP PROCEDURE IF EXISTS insert_ranger_team;
GO
CREATE PROCEDURE insert_ranger_team
    --input parameters for Ranger_team table 
    @team_ID INT, 
    @focus_area VARCHAR(64),
    @formation_date DATE
AS
BEGIN
    --insert into Ranger_team table with input parameters
    INSERT INTO Ranger_team
    VALUES
        (@team_ID, @focus_area, @formation_date);
END
GO
-------------------------------------------------------------------------------------------------
--create a new ranger who will be leader and assign them to a team using both stored procedures from query 2 above
--also, use stored procedures from query 1 to account for leader ranger having phone numbers, emails, and emergency contacts 

--create new stored procedure representing how one of the rangers that is assigned to a ranger team will be leading the team.
DROP PROCEDURE IF EXISTS set_leader;
GO
CREATE PROCEDURE set_leader
    --input parameters needed to insert into the Leader table 
    @team_ID INT,
    @person_ID INT
AS
BEGIN
    --insert into Leader table with input parameters
    INSERT INTO Leader
    VALUES
        (@team_ID, @person_ID);
END
GO


-----------------------------------------------------------------------------------------------
--Query 4. Insert a new donation from a donor (5/day). 
--would also use stored procedures from query 1 for adding emails, phone numbers, and emergency contacts 
--stored procedure for inserting donor into Person and Donor tables if they do not exist yet 
--use stored procedures from query 1 to account for donor possibly having multiple phone numbers, emails, and emergency contacts
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
--9.Retrieve the list of visitors enrolled in a specific park program, including their accessibility needs
DROP PROCEDURE IF EXISTS retrieve_visitor_enrollment;
GO
CREATE PROCEDURE retrieve_visitor_enrollment
    --program is identified by park_name and program_name (weak entity set)
    @park_name VARCHAR(64),
    @program_name VARCHAR(64)
AS
BEGIN 
SELECT Person.person_ID, first_name, last_name, visit_date, accessibility_needs
FROM Person, Enroll_in
WHERE Enroll_in.park_name = @park_name AND Enroll_in.program_name = @program_name AND Person.person_ID = Enroll_in.person_ID
END
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------
--10. Retrieve all park programs for a specific park that started after a given date 
DROP PROCEDURE IF EXISTS query_10;
GO
CREATE PROCEDURE query_10
    @park_name VARCHAR(64),
    @given_date DATE
AS
BEGIN 
--get all programs from a National park that started after given date using >
SELECT * 
FROM Program
WHERE park_name = @park_name AND program_start_date > @given_date;
END
GO

--11. Retrieve the total and average donation amount received in a month from all anonymous donors. The result must be sorted by total amount of the donation in descending order
SELECT SUM(amount) AS total_donations, AVG(amount) AS avg_donations
FROM 
(SELECT person_ID, donation_date, amount FROM Check_donation 
UNION 
SELECT person_ID, donation_date, amount FROM Credit_card_donation) AS all_donations)


--12. Retrieve the list of rangers in a team, including their certifications, years of service and their role in the team (leader or member)
--stored procedure to get list of all rangers in a team, including their id, name, status (active/inactive), years of service, and role (leader/member) 
DROP PROCEDURE IF EXISTS rangers_in_team;
GO
CREATE PROCEDURE rangers_in_team
--use team_ID to filter through Assigned_to table and get rangers on team with given team_ID
    @team_ID INT
AS
BEGIN 
--get current date to compute years of service
DECLARE @current_date DATE; 
SET @current_date = CONVERT(DATE, GETDATE()); --GETDATE() returns time, which we don't need so we convert to DATE (YYYY-MM-DD)

--CASE statement checks if person_ID for a ranger is in the Leader table (meaning that they are leader), and displays appropriate role for ranger
SELECT Person.person_ID, Person.first_name, Person.last_name, ranger_status, DATEDIFF(year, ranger_start_date, @current_date) AS years_of_service, 
CASE
WHEN Person.person_ID IN (SELECT Leader.person_ID FROM Leader WHERE team_ID = @team_ID) THEN 'leader' 
ELSE 'member'
END AS role 
FROM Assigned_to, Person
WHERE team_ID = @team_ID AND Person.person_ID = Assigned_to.person_ID;
END
GO

--create stored procedure to retrieve certifications for all rangers for team, with given team_ID
DROP PROCEDURE IF EXISTS get_ranger_certifications;
GO
CREATE PROCEDURE get_ranger_certifications
--use team_ID to filter through Ranger_certification for rangers on that team
    @team_ID INT
AS
BEGIN 
SELECT Assigned_to.person_ID, certification
FROM Assigned_to, Ranger_certification 
WHERE Assigned_to.person_ID = Ranger_certification.person_ID AND team_ID = @team_ID;
END
GO


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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


--14. Update the salary of researchers overseeing more than one ranger team by a 3% increase
--create stored procedure that updates salary for all researchers who oversee more than one ranger team 
--have to keep track of how many times they occur in the reports to (count)
DROP PROCEDURE IF EXISTS increase_researcher_salary;
GO
CREATE PROCEDURE increase_researcher_salary
AS
BEGIN 
UPDATE Researcher
SET salary = salary * 1.03
WHERE Researcher.person_ID IN 
--subquery gets all researchers who oversee more than one ranger team (count > 1)
--group by person_ID (researcher id) represents #teams that the researcher oversees
(SELECT person_ID
FROM Reports_to
GROUP BY person_ID
HAVING COUNT(*) > 1)
END
GO


--15.Delete visitors who have not enrolled in any park programs and whose park passes have expired
DROP PROCEDURE IF EXISTS delete_visitors;
GO
CREATE PROCEDURE delete_visitors
AS
BEGIN 
DECLARE @current_date DATE; --get current date to check if park passes expired
SET @current_date = CONVERT(DATE, GETDATE()); --GETDATE() also returns time, which we don't need so we convert to DATE (YYYY-MM-DD)

--UNION set operation gets all visitors who have enrolled in at least one program OR have at least one unexpired park pass (with no duplicates)
--if visitor is not in set above, that means they have not enrolled in any park programs AND all their park passes have expired. Therefore, delete them.
--only delete visitor if both conditions are not satisfied

--delete from Holds table first (since it references Visitor)
DELETE 
FROM Holds 
WHERE Holds.person_ID NOT IN (SELECT DISTINCT person_ID FROM Enroll_in
UNION 
SELECT DISTINCT person_ID FROM Holds, Park_pass WHERE Holds.pass_ID = Park_pass.pass_ID AND expiration_date > @current_date)

--then, delete from Enroll_in table (since it also references Visitor)
DELETE 
FROM Enroll_in 
WHERE Enroll_in.person_ID NOT IN (SELECT DISTINCT person_ID FROM Enroll_in
UNION 
SELECT DISTINCT person_ID FROM Holds, Park_pass WHERE Holds.pass_ID = Park_pass.pass_ID AND expiration_date > @current_date)

--finally, delete from Visitor table 
DELETE 
FROM Visitor
WHERE Visitor.person_ID NOT IN (SELECT DISTINCT person_ID FROM Enroll_in
UNION 
SELECT DISTINCT person_ID FROM Holds, Park_pass WHERE Holds.pass_ID = Park_pass.pass_ID AND expiration_date > @current_date)
END 
GO
