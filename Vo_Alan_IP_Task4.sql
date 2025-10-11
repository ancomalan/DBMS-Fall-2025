--create tables based on task 2

--drop tables in reverse order they are created (so foreign key constraintsa are not violated)
DROP TABLE IF EXISTS Operates;
DROP TABLE IF EXISTS Enroll_in;
DROP TABLE IF EXISTS Hosts; 
DROP TABLE IF EXISTS Reports_to;
DROP TABLE IF EXISTS Assigned_to;
DROP TABLE IF EXISTS Mentored_by;
DROP TABLE IF EXISTS Holds;
Drop TABLE IF EXISTS Credit_card_donation;
DROP TABLE IF EXISTS Check_donation;
DROP TABLE IF EXISTS Donation;
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



--person table (person_ID is primary key)
CREATE TABLE Person(
    person_ID INT PRIMARY KEY, 
    first_name VARCHAR(64) NOT NULL, 
    last_name VARCHAR(64) NOT NULL, 
    middle_initial CHAR(1),
    date_of_birth DATE, --format: YYYY-MM-DD
    gender CHAR (1) NOT NULL,
    street VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL, 
    state VARCHAR(20) NOT NULL,
    postal_code INT NOT NULL, 
    subscribed_to_newsletter CHAR(1) NOT NULL
    --age is derived attribute calculated from date of birth
);

--emergency_contact depends on person 
CREATE TABLE Emergency_contact(
    person_ID INT NOT NULL, 
    contact_name VARCHAR(64) NOT NULL, 
    relationship VARCHAR (10) NOT NULL,
    phone_number VARCHAR(20) NOT NULL,

    --multi-attribute primary key (person_ID and contact_name)
    CONSTRAINT PK_emergency_contact PRIMARY KEY (person_ID, contact_name),
    --enforce foreign key contraint to person_ID in person relation
    CONSTRAINT FK_emergency_contact FOREIGN KEY (person_ID) REFERENCES Person
);


--table for multivalued attribute for person having multiple phone numbers
CREATE TABLE Person_phone(
    person_ID INT NOT NULL, 
    phone_number VARCHAR(20) NOT NULL,

    --primary key consists of both attributes 
    CONSTRAINT PK_person_phone PRIMARY KEY (person_ID, phone_number),
    --foreign key of person_ID
    CONSTRAINT FK_person_phone FOREIGN KEY (person_ID) REFERENCES Person
);


--table for multivalued attribute for person having multiiple email addresses
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
    pass_type VARCHAR(20) NOT NULL, 
    expiration_date DATE
);


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
    research_field VARCHAR(64) NOT NULL, 
    hire_date DATE,
    salary INT NOT NULL, 
    CONSTRAINT FK_researcher FOREIGN KEY (person_ID) REFERENCES Person --foreign key of Person
);

--table for donor (inherits from Person)
CREATE TABLE Donor(
    person_ID INT PRIMARY KEY, 
    anonymity_preference CHAR(1),
    CONSTRAINT FK_donor FOREIGN KEY (person_ID) REFERENCES Person --foreign key of Person
);

--table for multivalued attribute (certifications) of ranger
CREATE TABLE Ranger_certification(
    person_ID INT NOT NULL, 
    certification VARCHAR(20) NOT NULL,

    --primary key consists of both attributes 
    CONSTRAINT PK_ranger_certification PRIMARY KEY (person_ID, certification),
    --foreign key of person_ID
    CONSTRAINT FK_ranger_certification FOREIGN KEY (person_ID) REFERENCES Person
);


--table for strong entity set Ranger_team
CREATE TABLE Ranger_team(
    team_ID INT PRIMARY KEY, 
    focus_area VARCHAR(64) NOT NULL,
    formation_date DATE,
    leader_ID INT NOT NULL, 
    
    --leader_ID references person_ID from Person table
    CONSTRAINT FK_leader_ID FOREIGN KEY (leader_ID) REFERENCES Person 
);


--table for National_park strong entity set
CREATE TABLE National_park(
    park_name VARCHAR(64) PRIMARY KEY, 
    street VARCHAR(64) NOT NULL, 
    city VARCHAR(30) NOT NULL, 
    state VARCHAR (30) NOT NULL, 
    postal_code INT NOT NULL, 
    establishment_date DATE, 
    visitor_capacity INT NOT NULL
);

--table for strong entity set Conservation_project 
CREATE TABLE Conservation_project(
    project_ID INT PRIMARY KEY,
    project_name VARCHAR(64) NOT NULL, 
    start_date DATE, 
    budget INT NOT NULL
);

--program depends on national_park (weak entity set)
CREATE TABLE Program(
    park_name VARCHAR(64) NOT NULL, 
    program_name VARCHAR(64) NOT NULL, 
    program_type VARCHAR (64) NOT NULL, 
    start_date DATE, 
    duration INT NOT NULL,

    --multi attribute primary key attribute (park_name and program_name)
    CONSTRAINT PK_program PRIMARY KEY (park_name, program_name),
    --foreign key constraints on park_name, which is from National_park
    CONSTRAINT FK_program FOREIGN KEY (park_name) REFERENCES National_park
);


--donation depends on donor (weak entity set)
CREATE TABLE Donation(
    person_ID INT NOT NULL, 
    date DATE, 
    amount INT NOT NULL, 
    campaign_name VARCHAR(64) NOT NULL, 

    --multi-attribute primary key (assuming that donor only donate once per day)
    CONSTRAINT PK_donation PRIMARY KEY (person_ID, date),
    --foreign key on person_ID from Person relation 
    CONSTRAINT FK_donation FOREIGN KEY (person_ID) REFERENCES Person
);


--Subclass of Donation (check donations)
CREATE TABLE Check_donation(
    person_ID INT NOT NULL, 
    date DATE, 
    check_number INT NOT NULL, 

    --primary key is same as Donation weak entity set
    CONSTRAINT PK_check_donation PRIMARY KEY (person_ID, date),
    --foreign key references multi-attribute primary key of Donation superclass (person_ID, date)
    CONSTRAINT FK_check_donation FOREIGN KEY (person_ID, date) REFERENCES Donation 
);

--Subclass of Donation (card donations)
CREATE TABLE Credit_card_donation(
    person_ID INT NOT NULL, 
    date DATE, 
    card_type VARCHAR(64) NOT NULL, 
    last_four_digits CHAR(4) NOT NULL , 
    expiration_date DATE,

    --primary key is same as Donation superclass
    CONSTRAINT PK_credit_card_donation PRIMARY KEY (person_ID, date),
    --foreign key references multi-attribute primary key of Donation superclass (person_ID, date)
    CONSTRAINT FK_credit_card_donation FOREIGN KEY (person_ID, date) REFERENCES Donation
);

--table representing one-to-many relationship between visitors and park passes
CREATE TABLE Holds(
    pass_ID INT PRIMARY KEY,    --primary key is on the many side of relationship 
    person_ID INT NOT NULL, 

    --foreign key constraints 
    CONSTRAINT FK_holds_pass FOREIGN KEY (pass_ID) references Park_pass,
    CONSTRAINT FK_holds_person FOREIGN KEY (person_ID) references Person
);

--table representing one to one relationship between rangers mentoring each other
CREATE TABLE Mentored_by(
    mentee_ID INT PRIMARY KEY, --primary key for one-to-one can be either mentee_ID or mentor_ID
    mentor_ID INT NOT NULL,
    start_date DATE, 

    --foreign key constraints 
    CONSTRAINT FK_mentee_ID FOREIGN KEY (mentee_ID) REFERENCES Ranger,
    CONSTRAINT FK_mentor_ID FOREIGN KEY (mentor_ID) REFERENCES Ranger
);

--table representing many to one relationship from Ranger to Ranger_team
CREATE TABLE Assigned_to(
    person_ID INT PRIMARY KEY, 
    team_ID INT NOT NULL, 
    start_date DATE, 
    status VARCHAR(10), --active or inactive
    --years of service is a derived attribute based on start_date

    --foreign key constraints 
    CONSTRAINT FK_assigned_to_person FOREIGN KEY (person_ID) REFERENCES Ranger,
    CONSTRAINT FK_assigned_to_team FOREIGN KEY (team_ID) REFERENCES Ranger_team
);


--table representing many-to-one relationship from ranger_team to researcher
CREATE TABLE Reports_to(
    team_ID INT NOT NULL, 
    report_date DATE, 
    person_ID INT NOT NULL, 
    activities_summary VARCHAR(1024) NOT NULL, 

    --multi-attribute primary key 
    CONSTRAINT PK_reports_to PRIMARY KEY (team_ID, report_date),
    --foreign key constraints
    CONSTRAINT FK_reports_to_team FOREIGN KEY (team_ID) REFERENCES Ranger_team,
    CONSTRAINT FK_reports_to_person_id FOREIGN KEY (person_ID) REFERENCES Researcher
);


--table representing one-to-many relationship between National_park and conservation_project 
CREATE TABLE Hosts(
    project_ID INT PRIMARY KEY, 
    park_name VARCHAR(64), 

    --foreign key constraints 
    CONSTRAINT FK_hosts_project FOREIGN KEY (project_ID) REFERENCES Conservation_project,
    CONSTRAINT FK_hosts_park FOREIGN KEY (park_name) REFERENCES National_park
);


--table representing many to many relationship between visitors and programs (weak entity set depending on national park)
CREATE TABLE Enroll_in(
    person_ID INT NOT NULL, 
    park_name VARCHAR(64) NOT NULL, 
    program_name VARCHAR(64) NOT NULL, 
    visit_date DATE, 
    accessibility_needs VARCHAR (500), 

    --multi-attribute primary key 
    CONSTRAINT PK_enroll_in PRIMARY KEY (person_ID, park_name, program_name),
    --foregin key constraints 
    CONSTRAINT FK_enroll_person FOREIGN KEY (person_ID) REFERENCES Visitor, 
    CONSTRAINT FK_enroll_program FOREIGN KEY (park_name, program_name) REFERENCES Program --primary key of program is (park_name and program_name)
);

--table representing many to many relationship between ranger teams and national parks \
CREATE TABLE Operates(
    team_ID INT NOT NULL, 
    park_name VARCHAR(64) NOT NULL, 

    --multi-attribute primary key constraint 
    CONSTRAINT PK_operates PRIMARY KEY (team_ID, park_name),
    --foregin key constraints 
    CONSTRAINT FK_operates_ranger_team FOREIGN KEY (team_ID) REFERENCES Ranger_team, 
    CONSTRAINT FK_operates_park_name FOREIGN KEY (park_name) REFERENCES National_park
);