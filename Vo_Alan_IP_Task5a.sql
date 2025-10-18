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
INSERT INTO Person 
(person_ID, first_name, last_name, middle_initial, date_of_birth, gender, street, city, us_state, postal_code, subscribed_to_newsletter)
VALUES 
(2,'Jason', 'Vo', 'T', '2006-06-05', 'M', '6508 Apple Drive', 
    'Spring', 'Texas', '12333', 'N');

INSERT INTO Ranger
(person_ID)
VALUES 
(2);

INSERT INTO Assigned_to
VALUES 
(2, 21, '2025/11/10', 'active', 'member' );

------------------------------------------------------------------------------------------------------------
--Query 3. Insert a new ranger team into the database and set its leader(1/month).
INSERT INTO Ranger_team
VALUES 
(9, 'Preservation of wildlife', '2023-10-10');

INSERT INTO Assigned_to
VALUES 
(3, 9, '2023-12-12', 'active', 'leader');

-----------------------------------------------------------------------------------------------
--Query 4. Insert a new donation from a donor (5/day). 
INSERT INTO Check_donation 
VALUES (4, '2025-12-12', 100000, 'blackpink rules', 12);


--5. Insert a new researcher into the database and associate them with one or more ranger teams (1/year).
--first, insert into the person table 





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


