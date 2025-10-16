--SQL statements that implement all queries 1-14 with error checking


--populate some data in National Park (assume that national parks already exist) for query 1
INSERT INTO National_park (park_name, street, city, us_state, postal_code, establishment_date, visitor_capacity)
VALUES 
('Yellowstone National Park', '1 Grand Loop Rd', 'Yellowstone', 'WY', '82190', '1872-03-01', 25000),
('Yosemite National Park', '9011 Village Dr', 'Yosemite Valley', 'CA', '95389', '1890-10-01', 20000),
('Grand Canyon National Park', '20 South Entrance Rd', 'Grand Canyon', 'AZ', '86023', '1919-02-26', 30000),
('Zion National Park', '1 Zion Park Blvd', 'Springdale', 'UT', '84767', '1919-11-19', 15000),
('Rocky Mountain National Park', '1000 US Hwy 36', 'Estes Park', 'CO', '80517', '1915-01-26', 18000);



-- ----------------------------------------------------------------------------------------------------------------------------------------------------
-- --Query 1: Insert a new visitor into the database and associate them with one or more park programs (10/day).
-- --use Transact SQL stored procedure     
-- DROP PROCEDURE IF EXISTS query_1;

-- GO
-- CREATE PROCEDURE query_1
-- --input parameters entered from the user 
--     @person_ID INT, 
--     @first_name VARCHAR(64), 
--     @last_name VARCHAR(64), 
--     @middle_initial CHAR(1), 
--     @date_of_birth DATE, 
--     @gender CHAR(1), 
--     @street VARCHAR(100),   
--     @city VARCHAR(30), 
--     @us_state CHAR(2), 
--     @postal_code VARCHAR(10), 
--     @subscribed_to_newsletter CHAR(1),
--     @park_name VARCHAR(64),
--     @program_name VARCHAR(64), 
--     @visit_date DATE,
--     @accessibility_needs VARCHAR(500)
-- AS
-- BEGIN
-- --if new person, perform all three queries 
--     IF NOT EXISTS (SELECT 1 FROM Person WHERE person_ID = @person_ID)
--         BEGIN 
--             --three queries below form a statement block, so we need to use BEGIN and END 
--             --insert into Person table first (parent class of Visitor) 
--             INSERT INTO Person VALUES (@person_ID, @first_name, @last_name, @middle_initial, @date_of_birth, @gender, @street, @city, @us_state, @postal_code, @subscribed_to_newsletter);
--             --insert into Visitor table 
--             INSERT INTO Visitor VALUES (@person_ID);
--             --associate visitor with one or more park programs 
--             INSERT INTO Enroll_in VALUES (@person_ID, @park_name, @program_name, @visit_date, @accessibility_needs);
--         END
--     ELSE
--         --otherwise, if person has more than one assocation with park program (already exist in Person and Visitor tables), only insert into Enroll_in to satisfy multiple assocations with park programs
--         INSERT INTO Enroll_in VALUES (@person_ID, @park_name, @program_name, @visit_date, @accessibility_needs);
-- END

-- -- Executing the procedure query_1
-- GO
-- EXEC query_1;

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
SELECT first_name, last_name, phone_number, email_address, subscribed_to_newsletter
FROM Person, Person_phone, Person_email
WHERE Person.person_ID = Person_phone.person_ID AND Person.person_ID = Person_email.person_ID;


