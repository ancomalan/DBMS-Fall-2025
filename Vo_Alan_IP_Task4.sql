--create tables based on task 2

--drop tables in reverse order they are created (so foreign key constraintsa are not violated)
DROP TABLE IF EXISTS Operates;
DROP TABLE IF EXISTS Enroll_in;
DROP TABLE IF EXISTS Hosts; 
DROP TABLE IF EXISTS Reports_to;
DROP TABLE IF EXISTS Leader;
DROP TABLE IF EXISTS Assigned_to;
DROP TABLE IF EXISTS Mentored_by;
DROP TABLE IF EXISTS Holds;
Drop TABLE IF EXISTS Credit_card_donation;
DROP TABLE IF EXISTS Check_donation;
DROP TABLE IF EXISTS Program; 
DROP TABLE IF EXISTS Conservation_project;
DROP TABLE IF EXISTS National_park;
DROP TABLE IF EXISTS Ranger_team;
DROP TABLE IF EXISTS Ranger_certification;
DROP TABLE IF EXISTS Donor;
DROP TABLE IF EXISTS Researcher;
DROP TABLE IF EXISTS Ranger;
DROP TABLE IF EXISTS Visitor;
DROP TABLE IF EXISTS Park_pass;
DROP TABLE IF EXISTS Person_email;
DROP TABLE IF EXISTS Person_phone;
DROP TABLE IF EXISTS Emergency_contact;
DROP TABLE IF EXISTS Person;



--Person table (person_ID is primary key)
CREATE TABLE Person(
    person_ID INT PRIMARY KEY, 
    first_name VARCHAR(64) NOT NULL, 
    last_name VARCHAR(64) NOT NULL, 
    middle_initial CHAR(1), --optional middle initial
    date_of_birth DATE, --format: YYYY-MM-DD
    gender CHAR (1) NOT NULL,
    street VARCHAR(100) NOT NULL,
    city VARCHAR(30) NOT NULL, 
    us_state CHAR(2) NOT NULL,
    postal_code VARCHAR (10) NOT NULL, 
    subscribed_to_newsletter CHAR(1) NOT NULL
    --age is derived attribute calculated from date of birth
);

--emergency_contact depends on person 
CREATE TABLE Emergency_contact(
    person_ID INT NOT NULL, 
    contact_name VARCHAR(50) NOT NULL, 
    relationship VARCHAR (20) NOT NULL,
    phone_number VARCHAR(20) NOT NULL,

    --multi-attribute primary key (include all attributes of weak entity as discriminators to be safe)
    CONSTRAINT PK_emergency_contact PRIMARY KEY (person_ID, contact_name, relationship, phone_number),
    --enforce foreign key contraint to person_ID in Person relation
    CONSTRAINT FK_emergency_contact FOREIGN KEY (person_ID) REFERENCES Person
);


--person can have multiple phone numbers (multivalued attribute)
CREATE TABLE Person_phone(
    person_ID INT NOT NULL, 
    phone_number VARCHAR(20) NOT NULL,

    --primary key consists of both attributes 
    CONSTRAINT PK_person_phone PRIMARY KEY (person_ID, phone_number),
    --foreign key of person_ID
    CONSTRAINT FK_person_phone FOREIGN KEY (person_ID) REFERENCES Person
);


--person can have multiple emails (multivalued attribute)
CREATE TABLE Person_email(
    person_ID INT NOT NULL, 
    email_address VARCHAR(50) NOT NULL,

    --primary key consists of both attributes 
    CONSTRAINT PK_person_email PRIMARY KEY (person_ID, email_address),
    --foreign key of person_ID
    CONSTRAINT FK_person_email FOREIGN KEY (person_ID) REFERENCES Person
);


--table for strong entity set Park_pass
CREATE TABLE Park_pass(
    pass_ID INT PRIMARY KEY,
    pass_type VARCHAR(20) NOT NULL, --annual, yearly, etc.
    expiration_date DATE
);

--four tables below account for overlapping specialization of Person
--table for visitor (inherits from Person)
CREATE TABLE Visitor(
    person_ID INT PRIMARY KEY,
    CONSTRAINT FK_visitor FOREIGN KEY (person_ID) REFERENCES Person --foreign key of Person
);

--table for ranger (inherits from Person)
CREATE TABLE Ranger(
    person_ID INT PRIMARY KEY,
    CONSTRAINT FK_ranger FOREIGN KEY (person_ID) REFERENCES Person --foreign key of Person
);

--table for researcher (inherits from Person)
CREATE TABLE Researcher(
    person_ID INT PRIMARY KEY, 
    research_field VARCHAR(40) NOT NULL, 
    hire_date DATE,
    salary NUMERIC(8,2), --Fixed point number, with user-specified precision of 8 digits, with 2 digits to the right of decimal point
    CONSTRAINT FK_researcher FOREIGN KEY (person_ID) REFERENCES Person --foreign key of Person
);

--table for donor (inherits from Person)
CREATE TABLE Donor(
    person_ID INT PRIMARY KEY, 
    anonymity_preference CHAR(1) NOT NULL, --'Y' or 'N'
    CONSTRAINT FK_donor FOREIGN KEY (person_ID) REFERENCES Person --foreign key of Person
);

--table for multivalued attribute (certifications) of ranger
CREATE TABLE Ranger_certification(
    person_ID INT NOT NULL, 
    certification VARCHAR(20) NOT NULL,

    --primary key consists of both attributes 
    CONSTRAINT PK_ranger_certification PRIMARY KEY (person_ID, certification),
    --person_ID references to person_ID in Ranger table
    CONSTRAINT FK_ranger_certification FOREIGN KEY (person_ID) REFERENCES Ranger
);


--table for strong entity set Ranger_team
CREATE TABLE Ranger_team(
    team_ID INT PRIMARY KEY, 
    focus_area VARCHAR(64) NOT NULL,
    formation_date DATE
);


--table for National_park strong entity set
CREATE TABLE National_park(
    park_name VARCHAR(64) PRIMARY KEY, 
    street VARCHAR(64) NOT NULL, 
    city VARCHAR(30) NOT NULL, 
    us_state CHAR(2) NOT NULL, 
    postal_code VARCHAR(10), 
    establishment_date DATE, 
    visitor_capacity INT NOT NULL
);

--table for strong entity set Conservation_project 
CREATE TABLE Conservation_project(
    project_ID INT PRIMARY KEY,
    project_name VARCHAR(64) NOT NULL, 
    proj_start_date DATE, 
    budget INT NOT NULL
);

--program depends on national_park (weak entity set)
CREATE TABLE Program(
    park_name VARCHAR(64) NOT NULL, 
    program_name VARCHAR(64) NOT NULL, 
    program_type VARCHAR (64) NOT NULL, --e.g., recreational or educational
    program_start_date DATE, 
    duration INT NOT NULL, --in hours 

    --multi attribute primary key attribute (park_name and program_name)
    CONSTRAINT PK_program PRIMARY KEY (park_name, program_name),
    --foreign key constraints on park_name, which is from National_park
    CONSTRAINT FK_program FOREIGN KEY (park_name) REFERENCES National_park
);


--donations must be either check or credit card (total disjoint) as represented by two tables below 
CREATE TABLE Check_donation(
    person_ID INT NOT NULL, --depends on donor id since donation is a weak entity set
    donation_date DATE,
    amount NUMERIC(8,2) NOT NULL, --Fixed point number, with user-specified precision of 8 digits, with 2 digits to the right of decimal point
    campaign_name VARCHAR(64), 
    check_number VARCHAR(20), 

    --primary key consists of person_ID, donation_Date, amount, campaign_name to be safe 
    CONSTRAINT PK_check_donation PRIMARY KEY (person_ID, donation_date, amount, campaign_name),
    --foreign key references person_ID in donor table
    CONSTRAINT FK_check_donation FOREIGN KEY (person_ID) REFERENCES Donor --person has to exist in Donor table in order to make donation
);

--Subclass of Donation (card donations)
CREATE TABLE Credit_card_donation(
    person_ID INT NOT NULL, --donor id
    donation_date DATE, 
    amount NUMERIC(8,2) NOT NULL, 
    campaign_name VARCHAR(64),
    card_type VARCHAR(64) NOT NULL, 
    last_four_digits CHAR(4) NOT NULL, 
    expiration_date DATE,

    --primary key consists of person_ID, donation_Date, amount, campaign_name to be safe (assuming that donor can only donate once per day)
    CONSTRAINT PK_credit_card_donation PRIMARY KEY (person_ID, donation_date, amount, campaign_name),
    --foreign key references person_ID in Donor table
    CONSTRAINT FK_credit_card_donation FOREIGN KEY (person_ID) REFERENCES Donor
);

--table representing one-to-many relationship between visitors and park passes
CREATE TABLE Holds(
    pass_ID INT PRIMARY KEY,    --primary key is on the many side of relationship 
    person_ID INT NOT NULL, 

    --foreign key constraints 
    CONSTRAINT FK_holds_pass FOREIGN KEY (pass_ID) references Park_pass,
    CONSTRAINT FK_holds_person FOREIGN KEY (person_ID) references Visitor
);

--table representing one to one relationship between rangers mentoring each other
CREATE TABLE Mentored_by(
    mentee_ID INT PRIMARY KEY, --primary key for one-to-one can be either mentee_ID or mentor_ID
    mentor_ID INT NOT NULL,
    mentorship_start_date DATE, 

    --foreign key constraints 
    CONSTRAINT FK_mentee_ID FOREIGN KEY (mentee_ID) REFERENCES Ranger,
    CONSTRAINT FK_mentor_ID FOREIGN KEY (mentor_ID) REFERENCES Ranger
);

--table representing many to one relationship from Ranger to Ranger_team
CREATE TABLE Assigned_to(
    person_ID INT PRIMARY KEY, 
    team_ID INT NOT NULL, 
    ranger_start_date DATE, 
    ranger_status VARCHAR(10), --active or inactive
    --years of service is a derived attribute based on start_date

    --foreign key constraints 
    CONSTRAINT FK_assigned_to_person FOREIGN KEY (person_ID) REFERENCES Ranger,
    CONSTRAINT FK_assigned_to_team FOREIGN KEY (team_ID) REFERENCES Ranger_team
);

--create a table representing how one of the rangers that is assigned to a ranger team will be leading the team.
CREATE TABLE Leader(
    team_ID INT PRIMARY KEY, 
    person_ID INT,

    --person must be assigned to a team first, before they can be leader 
    CONSTRAINT FK_Leader_person FOREIGN KEY (person_ID) REFERENCES Assigned_to,
    CONSTRAINT FK_Leader_team FOREIGN KEY (team_ID) REFERENCES Ranger_team
);


--table representing many-to-one relationship from ranger_team to researcher
CREATE TABLE Reports_to(
    team_ID INT NOT NULL, 
    report_date DATE, 
    person_ID INT NOT NULL, --researcher id
    activities_summary VARCHAR(1024) NOT NULL, 

    --multi-attribute primary key to allow teams to report on seperate dates 
    CONSTRAINT PK_reports_to PRIMARY KEY (team_ID, report_date),
    --foreign key constraints
    CONSTRAINT FK_reports_to_team FOREIGN KEY (team_ID) REFERENCES Ranger_team,
    CONSTRAINT FK_reports_to_person_id FOREIGN KEY (person_ID) REFERENCES Researcher --researcher has to exist in the Researcher table
);


--table representing one-to-many relationship between National_park and conservation_project 
CREATE TABLE Hosts(
    project_ID INT PRIMARY KEY, 
    park_name VARCHAR(64), 

    --foreign key constraints 
    CONSTRAINT FK_hosts_project FOREIGN KEY (project_ID) REFERENCES Conservation_project,
    CONSTRAINT FK_hosts_park FOREIGN KEY (park_name) REFERENCES National_park
);


--table representing many to many relationship between visitors enrolling in programs (weak entity set depending on national park)
CREATE TABLE Enroll_in(
    person_ID INT NOT NULL, --visitor must exist in visitor table
    park_name VARCHAR(64) NOT NULL, 
    program_name VARCHAR(64) NOT NULL, 
    visit_date DATE, 
    accessibility_needs VARCHAR (500), 

    --multi-attribute primary key 
    CONSTRAINT PK_enroll_in PRIMARY KEY (person_ID, park_name, program_name),
    --foregin key constraints 
    CONSTRAINT FK_enroll_person FOREIGN KEY (person_ID) REFERENCES Visitor, 
    CONSTRAINT FK_enroll_program FOREIGN KEY (park_name, program_name) REFERENCES Program --composite foreign key since primary key of program is (park_name and program_name)
);

--table representing many to many relationship between ranger teams and national parks 
CREATE TABLE Operates(
    team_ID INT NOT NULL, 
    park_name VARCHAR(64) NOT NULL, 

    --multi-attribute primary key constraint 
    CONSTRAINT PK_operates PRIMARY KEY (team_ID, park_name),
    --foreign key constraints 
    CONSTRAINT FK_operates_ranger_team FOREIGN KEY (team_ID) REFERENCES Ranger_team, 
    CONSTRAINT FK_operates_park_name FOREIGN KEY (park_name) REFERENCES National_park
);