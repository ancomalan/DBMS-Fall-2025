
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Scanner;

public class Vo_Alan_IP_Task5b {

	// Database credentials
	final static String HOSTNAME = "vo0063-sql-server.database.windows.net";
	final static String DBNAME = "cs-dsa-4513-sql-db";
	final static String USERNAME = "vo0063";
	final static String PASSWORD = "A1@njas0n";

	// Database connection string
	final static String URL = String.format(
			"jdbc:sqlserver://%s:1433;database=%s;user=%s;password=%s;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;",
			HOSTNAME, DBNAME, USERNAME, PASSWORD);

	// Query templates
	// query 13: Retrieve the names, IDs, contact information, and newsletter
	// subscription status of all individuals in the database (following three
	// queries)
	final static String RETRIEVE_PEOPLE = "SELECT person_ID, first_name, last_name, middle_initial, subscribed_to_newsletter FROM Person; ";
	final static String RETRIEVE_PHONE_NUMBERS = "SELECT * FROM Person_phone; ";
	final static String RETRIEVE_EMAILS = "SELECT * FROM Person_email; ";

	// User input prompt
	final static String PROMPT = "\nPlease select one of the options below: \n"
			+ "1) Insert a new visitor into the database and associate them with one or more park programs; \n"
			+ "2) Insert a new ranger into the database and assign them to a ranger team; \n"
			+ "3) Insert a new ranger team into the database and set its leader; \n"
			+ "4) Insert a new donation from a donor; \n"
			+ "5) Insert a new researcher into the database and associate them with one or more ranger teams; \n"
			+ "6) Insert a report submitted by a ranger team to a researcher; \n"
			+ "7) Insert a new park program into the database for a specific park; \n"
			+ "8) Retrieve the names and contact information of all emergency contacts for a specific person; \n"
			+ "9) Retrieve the list of visitors enrolled in a specific park program, including their accessibility needs; \n"
			+ "10) Retrieve all park programs for a specific park that started after a given date; \n"
			+ "13) Retrieve the names, IDs, contact information, and newsletter subscription status of all individuals in the database; \n"
			+ "18) Quit";

	public static void main(String[] args) throws SQLException {

		System.out.println("WELCOME TO THE NATIONAL PARK SERVICE SYSTEM DATABASE");

		final Scanner sc = new Scanner(System.in); // Scanner is used to collect the user input
		String option = ""; // Initialize user option selection as nothing
		while (!option.equals("18")) { // Ask user for options until option 18 is selected
			System.out.println(PROMPT); // Print the available options
			option = sc.next(); // Read in the user option selection

			switch (option) { // Switch between different options
			case "1": // Insert a new visitor and associate them with one or more park programs
				// Collect input data from user
				System.out.println("Please enter visitor's ID: ");
				final int visitor_ID = sc.nextInt(); // Read in the user input for person_ID

				System.out.println("Please enter visitor's first name:");
				// Preceding nextInt, nextFloat, etc. does not consume new line characters from
				// the user input.
				// We call nextLine to consume that newline character, so that subsequent
				// nextLine doesn't return nothing.
				sc.nextLine();
				final String visitor_first_name = sc.nextLine(); // Read in user input of Person's First Name
				// (white-spaces allowed).

				System.out.println("Please enter visitor's last name:");
				// No need to call nextLine extra time here, because the preceding nextLine
				// consumed the newline character.
				final String visitor_last_name = sc.nextLine(); // Read in user input of person Last Name
				// (white-spaces
				// allowed).

				System.out.println("Please enter visitor's middle initial (1 character, if any): ");
				final String visitor_middle_initial = sc.nextLine();

				System.out.println("Please enter visitor's DOB (YYYY-MM-DD): ");
				final String visitor_DOB = sc.nextLine();

				System.out.println("Please enter visitor's gender (M or F): ");
				final String visitor_gender = sc.nextLine();

				System.out.println("Please enter visitor's street address: ");
				final String visitor_street = sc.nextLine();

				System.out.println("Please enter visitor's city: ");
				final String visitor_city = sc.nextLine();

				System.out.println("Please enter visitor's state abbreviation (e.g., AZ): ");
				final String visitor_state = sc.nextLine();

				System.out.println("Please enter visitor's postal code: ");
				final String visitor_postal_code = sc.nextLine();

				System.out.println("Is person subscribed to newsletter from NPSS? (Y or N): ");
				final String visitor_subscription_status = sc.nextLine();

				// execute queries in database
				System.out.println("Connecting to the database...");
				// Get a database connection and prepare a query statement
				try (final Connection connection = DriverManager.getConnection(URL)) {
					// insert into Person and Visitor tables using stored procedure
					try (final PreparedStatement statement = connection.prepareStatement(
							"EXEC insert_visitor @person_ID = ?, @first_name = ?, @last_name = ?, @middle_initial = ?, @date_of_birth = ?, @gender = ?, @street = ?, @city = ?, @us_state = ?, @postal_code = ?, @subscribed_to_newsletter = ?;")) {
						// Populate the query template with the data collected from the user
						statement.setInt(1, visitor_ID);
						statement.setString(2, visitor_first_name);
						statement.setString(3, visitor_last_name);
						statement.setString(4, visitor_middle_initial);
						statement.setString(5, visitor_DOB);
						statement.setString(6, visitor_gender);
						statement.setString(7, visitor_street);
						statement.setString(8, visitor_city);
						statement.setString(9, visitor_state);
						statement.setString(10, visitor_postal_code);
						statement.setString(11, visitor_subscription_status);

						// Actually execute the populated query
						final int rows_inserted = statement.executeUpdate();
						System.out.println(String.format("Done. %d rows inserted into Person and Visitor table.",
								rows_inserted));
					}
					// associate visitor with 1 or more park programs using stored procedure
					try (final PreparedStatement statement = connection.prepareStatement(
							"EXEC enroll_visitors @person_ID = ?, @park_name = ?, @program_name = ?, @visit_date = ?, @accessibility_needs = ?;")) {
						// associate them with one or more programs
						System.out.println(
								"How many park programs would you like to associate with this visitor (0 for none)? ");
						final int number_programs = sc.nextInt();
						sc.nextLine(); // consume newline from preceding nextInt

						// use for loop to associate visitor with multiple park programs (by inserting
						// them multiple times into the Enroll_in table)
						for (int i = 0; i < number_programs; i++) {
							// get park_name, program_name, visit_date, and accessibility_needs (program
							// information)
							// variables are not final because they must be reassigned after every iteration
							// Program and National Park data have to already exist in the database because
							// of foreign key constraints (we can populate Programs with query 7)
							System.out.println("Please enter National Park name: ");
							String park_name = sc.nextLine();

							System.out.println("Please enter program name: ");
							String program_name = sc.nextLine();

							System.out.println("Please enter visit date (YYYY-MM-DD): ");
							String visit_date = sc.nextLine();

							System.out.println("Please enter visitor's accessibility needs: ");
							String accessibility_needs = sc.nextLine();

							// populate query template
							statement.setInt(1, visitor_ID);
							statement.setString(2, park_name);
							statement.setString(3, program_name);
							statement.setString(4, visit_date);
							statement.setString(5, accessibility_needs);

							// Actually execute the populated query
							final int rows_inserted = statement.executeUpdate();
							System.out.println(
									String.format("Done. %d rows inserted into the Enroll_in table.",
											rows_inserted));
						}
					}
					// account for visitor holding park passes (query 15)
					try (
							// use stored procedure to insert into Park_pass and Holds tables to account for
							// how visitors can hold many park passes
							final PreparedStatement statement = connection.prepareStatement(
									"EXEC visitor_passes @pass_ID = ?, @pass_type = ?, @expiration_date = ?, @person_ID = ?;")) {
						// associate visitor with one or more park passes
						System.out.println(
								"How many park passes would you like to associate with this visitor (0 for none)? ");
						final int number_passes = sc.nextInt();
						sc.nextLine(); // consume newline from preceding nextInt

						// use for loop to associate visitor with multiple park passes, if any
						for (int i = 0; i < number_passes; i++) {
							// variables are not final because they have to be reassigned after every
							// iteration
							System.out.println("Please enter pass ID: ");
							int pass_ID = sc.nextInt();
							sc.nextLine();// consume newline from preceding nextInt

							System.out.println("Please enter pass type (e.g., annual, day): ");
							String pass_type = sc.nextLine();

							System.out.println("Please enter expiration date for pass (YYYY-MM-DD): ");
							String pass_expiration_date = sc.nextLine();

							// set input parameters for stored procedure
							statement.setInt(1, pass_ID);
							statement.setString(2, pass_type);
							statement.setString(3, pass_expiration_date);
							statement.setInt(4, visitor_ID);
							// execute stored procedure
							final int rows_inserted = statement.executeUpdate();
							System.out.println(
									String.format("Done. %d rows inserted into the Park_pass and Holds tables.",
											rows_inserted));
						}
					}
					// account for multi-valued attributes of phone numbers using stored procedure
					try (final PreparedStatement statement = connection
							.prepareStatement("EXEC add_phone @person_ID = ?, @phone_number = ?;")) {
						System.out
						.println("How many phone numbers would you like to add for visitor (0 for none)?");
						final int number_phones = sc.nextInt();
						sc.nextLine();// consume new line character from nextInt

						// loop based on how many phone numbers that the user wants to insert
						for (int i = 0; i < number_phones; i++) {
							System.out.println("Please enter phone number for visitor: ");
							String phone_number = sc.nextLine(); // variable is not final since it needs to be
							// reassigned after every iteration

							// populate query template
							statement.setInt(1, visitor_ID);
							statement.setString(2, phone_number);
							// Actually execute the populated query
							final int rows_inserted = statement.executeUpdate();
							System.out.println(
									String.format("Done. %d rows inserted into Person_phone table.",
											rows_inserted));
						}
					}
					// account for multi-valued attribute of emails
					try (final PreparedStatement statement = connection
							.prepareStatement("EXEC add_email @person_ID = ?, @email_address = ?;")) {
						System.out.println(
								"How many email addresses would you like to add for visitor (0 for none)?");
						final int number_emails = sc.nextInt();
						sc.nextLine();// consume new line character from nextInt

						// loop based on how many phone numbers that the user wants to insert
						for (int i = 0; i < number_emails; i++) {
							System.out.println("Please enter email for visitor: ");
							String email = sc.nextLine(); // variable is not final since it needs to be reassigned
							// after
							// every iteration

							// populate query template
							statement.setInt(1, visitor_ID);
							statement.setString(2, email);
							// Actually execute the populated query
							final int rows_inserted = statement.executeUpdate();
							System.out.println(
									String.format("Done. %d rows inserted into Person_email table.",
											rows_inserted));
						}
					}
					// lastly, account for emergency contacts that each visitor might have (query 8)
					try (final PreparedStatement statement = connection
							.prepareStatement(
									"EXEC add_emergency_contact @person_ID = ?, @contact_name = ?, @relationship = ?, @phone_number = ?;")) {
						System.out.println(
								"How many emergency contacts would you like to add for this visitor (0 for none)?");
						final int number_contacts = sc.nextInt(); // use in for loop
						sc.nextLine();// consume new line character from nextInt

						// loop based on how many emergency contacts that the user wants to insert
						for (int i = 0; i < number_contacts; i++) {
							// collect all attributes for Emergency_contact
							System.out.println("Please enter contact name for visitor: ");
							String contact_name = sc.nextLine(); // variable is not final since it needs to be
							// reassigned after every iteration
							System.out.println("Please enter relationship to the visitor: ");
							String relationship = sc.nextLine();
							System.out.println("Please enter phone number for emergency contact: ");
							String emergency_phone_number = sc.nextLine();

							// populate query template
							statement.setInt(1, visitor_ID);
							statement.setString(2, contact_name);
							statement.setString(3, relationship);
							statement.setString(4, emergency_phone_number);

							// Actually execute the populated query
							final int rows_inserted = statement.executeUpdate();
							System.out.println(String.format("Done. %d rows inserted into Emergency_contact table.",
									rows_inserted));
						}
					}
				}
				break;
			case "2":
				// Collect input data from user
				System.out.println("Please enter ranger's ID: ");
				final int ranger_ID = sc.nextInt(); // Read in the user input for person_ID
				sc.nextLine(); // consume newline character from nextInt

				System.out.println("Please enter ranger's first name:");
				final String ranger_first_name = sc.nextLine();

				System.out.println("Please enter ranger's last name:");
				final String ranger_last_name = sc.nextLine();

				System.out.println("Please enter ranger's middle initial (1 character, if any): ");
				final String ranger_middle_initial = sc.nextLine();

				System.out.println("Please enter ranger's DOB (YYYY-MM-DD): ");
				final String ranger_DOB = sc.nextLine();

				System.out.println("Please enter ranger's gender (M or F): ");
				final String ranger_gender = sc.nextLine();

				System.out.println("Please enter ranger's street address: ");
				final String ranger_street = sc.nextLine();

				System.out.println("Please enter ranger's city: ");
				final String ranger_city = sc.nextLine();

				System.out.println("Please enter ranger's state abbreviation (e.g., AZ): ");
				final String ranger_state = sc.nextLine();

				System.out.println("Please enter ranger's postal code: ");
				final String ranger_postal_code = sc.nextLine();

				System.out.println("Is person subscribed to newsletter from NPSS? (Y or N): ");
				final String ranger_subscription_status = sc.nextLine();

				System.out.println("Please enter ranger team's team_ID that you want to assign ranger to: "); //assuming that ranger team already exists in database
				final int ranger_team_ID = sc.nextInt();
				sc.nextLine();// consume new line character from preceding line
				System.out.println("Please enter ranger's start date (YYYY-MM-DD): ");
				final String ranger_start_date = sc.nextLine();
				System.out.println("Please enter ranger's status (active or inactive): ");
				final String ranger_status = sc.nextLine();

				// execute queries in database
				System.out.println("Connecting to the database...");
				// Get a database connection and prepare a query statement
				try (final Connection connection = DriverManager.getConnection(URL)) {
					// insert into Person, Ranger, and Assigned_to tables using stored procedure
					try (final PreparedStatement statement = connection.prepareStatement(
							"EXEC query_2 @person_ID = ?, @first_name = ?, @last_name = ?, @middle_initial = ?, @date_of_birth = ?, @gender = ?, @street = ?, @city = ?, @us_state = ?, @postal_code = ?, @subscribed_to_newsletter = ?, @team_ID = ?, @ranger_start_date = ?, @ranger_status = ?;")) {
						// Setting the storage procedure input parameter values
						statement.setInt(1, ranger_ID);
						statement.setString(2, ranger_first_name);
						statement.setString(3, ranger_last_name);
						statement.setString(4, ranger_middle_initial);
						statement.setString(5, ranger_DOB);
						statement.setString(6, ranger_gender);
						statement.setString(7, ranger_street);
						statement.setString(8, ranger_city);
						statement.setString(9, ranger_state);
						statement.setString(10, ranger_postal_code);
						statement.setString(11, ranger_subscription_status);
						statement.setInt(12, ranger_team_ID);
						statement.setString(13, ranger_start_date);
						statement.setString(14, ranger_status);

						// Actually execute the populated query
						final int rows_inserted = statement.executeUpdate();
						System.out.println(String.format(
								"Done. %d rows inserted into Person, Ranger, and Assigned_to tables.",
								rows_inserted));
					}
					// account for multi-valued attributes of ranger certifications
					try (final PreparedStatement statement = connection.prepareStatement("EXEC add_ranger_certification @person_ID = ?, @certification = ?;")) {
						System.out.println("How many certifications would you like to add for ranger (0 for none)?");
						final int num_certifications = sc.nextInt();
						sc.nextLine();// consume new line character from nextInt

						// loop based on how many certifications that the user wants to insert
						for (int i = 0; i < num_certifications; i++) {
							System.out.println("Please enter certification for ranger: ");
							String certification = sc.nextLine(); // variable is not final since it needs to be
							// reassigned after every iteration

							// populate query template
							statement.setInt(1, ranger_ID);
							statement.setString(2, certification);
							// Actually execute the populated query
							final int rows_inserted = statement.executeUpdate();
							System.out.println(
									String.format("Done. %d rows inserted into Ranger_certification table.",
											rows_inserted));
						}
					}
					// account for multi-valued attribute of phone numbers
					try (final PreparedStatement statement = connection
							.prepareStatement("EXEC add_phone @person_ID = ?, @phone_number = ?;")) {
						System.out.println("How many phone numbers would you like to add for ranger (0 for none)?");
						final int num_phones = sc.nextInt();
						sc.nextLine();// consume new line character from nextInt

						// loop based on how many phone numbers that the user wants to insert
						for (int i = 0; i < num_phones; i++) {
							System.out.println("Please enter phone number for ranger: ");
							String phone_number = sc.nextLine(); // variable is not final since it needs to be
							// reassigned after every iteration

							// set stored procedure input parameters
							statement.setInt(1, ranger_ID);
							statement.setString(2, phone_number);
							// Actually execute the populated query
							final int rows_inserted = statement.executeUpdate();
							System.out.println(
									String.format("Done. %d rows inserted into Person_phone table.",
											rows_inserted));
						}
					}
					// account for multi-valued attribute of email
					try (final PreparedStatement statement = connection
							.prepareStatement("EXEC add_email @person_ID = ?, @email_address = ?;")) {
						System.out
						.println("How many email addresses would you like to add for ranger (0 for none)?");
						final int num_emails = sc.nextInt();
						sc.nextLine();// consume new line character from nextInt

						// loop based on how many phone numbers that the user wants to insert
						for (int i = 0; i < num_emails; i++) {
							System.out.println("Please enter email for ranger: ");
							String email = sc.nextLine(); // variable is not final since it needs to be reassigned
							// after
							// every iteration

							// set input parameters for stored procedure
							statement.setInt(1, ranger_ID);
							statement.setString(2, email);
							// Actually execute the populated query
							final int rows_inserted = statement.executeUpdate();
							System.out.println(
									String.format("Done. %d rows inserted into Person_email table.",
											rows_inserted));
						}
					}
					// lastly, account for emergency contacts that each ranger might have (used in
					// query 8)
					try (final PreparedStatement statement = connection.prepareStatement(
							"EXEC add_emergency_contact @person_ID = ?, @contact_name = ?, @relationship = ?, @phone_number = ?;")) {
						System.out.println(
								"How many emergency contacts would you like to add for this ranger (0 for none)?");
						final int number_contacts = sc.nextInt(); // use in for loop
						sc.nextLine();// consume new line character from nextInt

						// loop based on how many emergency contacts that the user wants to insert
						for (int i = 0; i < number_contacts; i++) {
							// collect all attributes for Emergency_contact
							System.out.println("Please enter emergency contact name: ");
							String contact_name = sc.nextLine(); // variable is not final since it needs to be
							// reassigned after every iteration
							System.out.println("Please enter relationship to the ranger: ");
							String relationship = sc.nextLine();
							System.out.println("Please enter phone number for emergency contact: ");
							String emergency_phone_number = sc.nextLine();

							// populate query template
							statement.setInt(1, ranger_ID);
							statement.setString(2, contact_name);
							statement.setString(3, relationship);
							statement.setString(4, emergency_phone_number);

							// Actually execute the populated query
							final int rows_inserted = statement.executeUpdate();
							System.out.println(String.format("Done. %d rows inserted into Emergency_contact table.",
									rows_inserted));
						}
					}
				}
				break;
			case "3":
				// Collect input to insert into Ranger_team table
				System.out.println("Please enter new ranger team's id: ");
				final int new_team_ID = sc.nextInt(); 
				sc.nextLine();//consume newline character from preceding nextInt()
				System.out.println("Please enter new ranger team's focus area (e.g., wildlife protection): ");
				final String focus_area = sc.nextLine();
				System.out.println("Please enter new ranger team's formation date (YYYY-MM-DD): ");
				final String formation_date = sc.nextLine();

				//get user input to create new ranger who will lead the team and assign them to the new ranger team
				System.out.println("Please enter team leader's id: ");
				final int leader_ID = sc.nextInt(); 
				sc.nextLine(); // consume newline character from nextInt

				System.out.println("Please enter team leader's first name:");
				final String leader_first_name = sc.nextLine();

				System.out.println("Please enter team leader's last name:");
				final String leader_last_name = sc.nextLine();

				System.out.println("Please enter team leader's middle initial (1 character, if any): ");
				final String leader_middle_initial = sc.nextLine();

				System.out.println("Please enter team leader's DOB (YYYY-MM-DD): ");
				final String leader_DOB = sc.nextLine();

				System.out.println("Please enter team leader's gender (M or F): ");
				final String leader_gender = sc.nextLine();

				System.out.println("Please enter team leader's street address: ");
				final String leader_street = sc.nextLine();

				System.out.println("Please enter team leader's city: ");
				final String leader_city = sc.nextLine();

				System.out.println("Please enter team leader's state abbreviation (e.g., AZ): ");
				final String leader_state = sc.nextLine();

				System.out.println("Please enter leader's postal code: ");
				final String leader_postal_code = sc.nextLine();

				System.out.println("Is team leader subscribed to newsletter from NPSS? (Y or N): ");
				final String leader_subscription_status = sc.nextLine();

				System.out.println("Please enter team leader's start date (YYYY-MM-DD): ");
				final String leader_start_date = sc.nextLine();
				System.out.println("Please enter team leader's status (active or inactive): ");
				final String leader_status = sc.nextLine();

				// execute queries in database
				System.out.println("Connecting to the database...");
				// Get a database connection and prepare a query statement
				try (final Connection connection = DriverManager.getConnection(URL)) {
					//use stored procedure to insert new ranger team into the database
					try (final PreparedStatement statement = connection.prepareStatement(
							"EXEC insert_ranger_team @team_ID = ?, @focus_area = ?, @formation_date = ?;")) {
						// Setting the storage procedure input parameter values
						statement.setInt(1, new_team_ID);
						statement.setString(2, focus_area);
						statement.setString(3, formation_date);

						// Actually execute the populated query
						final int rows_inserted = statement.executeUpdate();
						System.out.println(String.format(
								"Done. %d rows inserted into Ranger_team table.",
								rows_inserted));
					}
					//create new ranger who will be team leader for new ranger team
					// insert into Person, Ranger, and Assigned_to tables using stored procedure
					try (final PreparedStatement statement = connection.prepareStatement(
							"EXEC query_2 @person_ID = ?, @first_name = ?, @last_name = ?, @middle_initial = ?, @date_of_birth = ?, @gender = ?, @street = ?, @city = ?, @us_state = ?, @postal_code = ?, @subscribed_to_newsletter = ?, @team_ID = ?, @ranger_start_date = ?, @ranger_status = ?;")) {
						// Setting the storage procedure input parameter values
						statement.setInt(1, leader_ID);
						statement.setString(2, leader_first_name);
						statement.setString(3, leader_last_name);
						statement.setString(4, leader_middle_initial);
						statement.setString(5, leader_DOB);
						statement.setString(6, leader_gender);
						statement.setString(7, leader_street);
						statement.setString(8, leader_city);
						statement.setString(9, leader_state);
						statement.setString(10, leader_postal_code);
						statement.setString(11, leader_subscription_status);
						statement.setInt(12, new_team_ID);
						statement.setString(13, leader_start_date);
						statement.setString(14, leader_status);

						// Actually execute the populated query
						final int rows_inserted = statement.executeUpdate();
						System.out.println(String.format(
								"Done. %d rows inserted into Person, Ranger, and Assigned_to tables.",
								rows_inserted));
					}
					// account for multi-valued attributes of ranger certifications for the team leader
					try (final PreparedStatement statement = connection.prepareStatement("EXEC add_ranger_certification @person_ID = ?, @certification = ?;")) {
						System.out.println("How many certifications would you like to add for team leader (0 for none)?");
						final int num_certifications = sc.nextInt();
						sc.nextLine();// consume new line character from nextInt

						// loop based on how many certifications that the user wants to insert
						for (int i = 0; i < num_certifications; i++) {
							System.out.println("Please enter certification for team leader: ");
							String certification = sc.nextLine(); // variable is not final since it needs to be
							// reassigned after every iteration

							// populate query template
							statement.setInt(1, leader_ID);
							statement.setString(2, certification);
							// Actually execute the populated query
							final int rows_inserted = statement.executeUpdate();
							System.out.println(
									String.format("Done. %d rows inserted into Ranger_certification table.",
											rows_inserted));
						}
					}
					// account for multi-valued attribute of phone numbers
					try (final PreparedStatement statement = connection
							.prepareStatement("EXEC add_phone @person_ID = ?, @phone_number = ?;")) {
						System.out.println("How many phone numbers would you like to add for team leader (0 for none)?");
						final int num_phones = sc.nextInt();
						sc.nextLine();// consume new line character from nextInt

						// loop based on how many phone numbers that the user wants to insert
						for (int i = 0; i < num_phones; i++) {
							System.out.println("Please enter phone number for team leader: ");
							String phone_number = sc.nextLine(); // variable is not final since it needs to be
							// reassigned after every iteration

							// set stored procedure input parameters
							statement.setInt(1, leader_ID);
							statement.setString(2, phone_number);
							// Actually execute the populated query
							final int rows_inserted = statement.executeUpdate();
							System.out.println(
									String.format("Done. %d rows inserted into Person_phone table.",
											rows_inserted));
						}
					}
					// account for multi-valued attribute of email
					try (final PreparedStatement statement = connection
							.prepareStatement("EXEC add_email @person_ID = ?, @email_address = ?;")) {
						System.out
						.println("How many email addresses would you like to add for team leader (0 for none)?");
						final int num_emails = sc.nextInt();
						sc.nextLine();// consume new line character from nextInt

						// loop based on how many phone numbers that the user wants to insert
						for (int i = 0; i < num_emails; i++) {
							System.out.println("Please enter email for team leader: ");
							String email = sc.nextLine(); // variable is not final since it needs to be reassigned
							// after
							// every iteration

							// set input parameters for stored procedure
							statement.setInt(1, leader_ID);
							statement.setString(2, email);
							// Actually execute the populated query
							final int rows_inserted = statement.executeUpdate();
							System.out.println(
									String.format("Done. %d rows inserted into Person_email table.",
											rows_inserted));
						}
					}
					// lastly, account for emergency contacts that each team leader might have (used in query 8)
					try (final PreparedStatement statement = connection.prepareStatement(
							"EXEC add_emergency_contact @person_ID = ?, @contact_name = ?, @relationship = ?, @phone_number = ?;")) {
						System.out.println("How many emergency contacts would you like to add for this team leader (0 for none)?");
						final int number_contacts = sc.nextInt(); // use in for loop
						sc.nextLine();// consume new line character from nextInt

						// loop based on how many emergency contacts that the user wants to insert
						for (int i = 0; i < number_contacts; i++) {
							// collect all attributes for Emergency_contact
							System.out.println("Please enter emergency contact name: ");
							String contact_name = sc.nextLine(); // variable is not final since it needs to be
							// reassigned after every iteration
							System.out.println("Please enter relationship to the team leader: ");
							String relationship = sc.nextLine();
							System.out.println("Please enter phone number for emergency contact: ");
							String emergency_phone_number = sc.nextLine();

							// populate query template
							statement.setInt(1, leader_ID);
							statement.setString(2, contact_name);
							statement.setString(3, relationship);
							statement.setString(4, emergency_phone_number);

							// Actually execute the populated query
							final int rows_inserted = statement.executeUpdate();
							System.out.println(String.format("Done. %d rows inserted into Emergency_contact table.",
									rows_inserted));
						}
					}
					//set this ranger as the leader of the new ranger team using stored procedure 
					try (final PreparedStatement statement = connection.prepareStatement("EXEC set_leader @team_ID = ?, @person_ID = ?;")) {

						// populate query template
						statement.setInt(1, new_team_ID);
						statement.setInt(2, leader_ID);
						// Actually execute the populated query
						final int rows_inserted = statement.executeUpdate();
						System.out.println(String.format("Done. %d rows inserted into Leader table.",
								rows_inserted));
					}
				}
				break;
			case "4":
				// insert a new donor if they do not already exist, otherwise add donation for existing donor
				// insert some anonymous and some not to test query 11
				sc.nextLine();//consume new line character from sc.next()
				System.out.println("Does donor already exist (Y or N)?");
				final String donor_exists = sc.nextLine();


				// execute queries in database
				System.out.println("Connecting to the database...");
				// Get a database connection and prepare a query statement
				try (final Connection connection = DriverManager.getConnection(URL)) {
					// create new donor accounting for them having multiple phone #'s, emails, and emergency contacts 
					System.out.println("Please enter donor's ID: ");
					final int donor_ID = sc.nextInt();
					sc.nextLine(); // consume newline character from nextInt

					if (donor_exists.equalsIgnoreCase("N")) {
						System.out.println("Please enter donor's first name:");
						final String donor_first_name = sc.nextLine();

						System.out.println("Please enter donor's last name:");
						final String donor_last_name = sc.nextLine();

						System.out.println("Please enter donor's middle initial (1 character, if any): ");
						final String donor_middle_initial = sc.nextLine();

						System.out.println("Please enter donor's DOB (YYYY-MM-DD): ");
						final String donor_DOB = sc.nextLine();

						System.out.println("Please enter donor's gender (M or F): ");
						final String donor_gender = sc.nextLine();

						System.out.println("Please enter donor's street address: ");
						final String donor_street = sc.nextLine();

						System.out.println("Please enter donor's city: ");
						final String donor_city = sc.nextLine();

						System.out.println("Please enter donor's state abbreviation (e.g., AZ): ");
						final String donor_state = sc.nextLine();

						System.out.println("Please enter donor's postal code: ");
						final String donor_postal_code = sc.nextLine();

						System.out.println("Is donor subscribed to newsletter from NPSS? (Y or N): ");
						final String donor_subscription_status = sc.nextLine();

						System.out.println("Is donor anonymous (Y or N)? "); // ask if donor is anonymous or not
						final String anonymity_preference = sc.nextLine();

						try (final PreparedStatement statement = connection.prepareStatement(
								"EXEC insert_donor @person_ID = ?, @first_name = ?, @last_name = ?, @middle_initial = ?, @date_of_birth = ?, @gender = ?, @street = ?, @city = ?, @us_state = ?, @postal_code = ?, @subscribed_to_newsletter = ?, @anonymity_preference = ?;")) {
							// Setting the storage procedure input parameter values
							statement.setInt(1, donor_ID);
							statement.setString(2, donor_first_name);
							statement.setString(3, donor_last_name);
							statement.setString(4, donor_middle_initial);
							statement.setString(5, donor_DOB);
							statement.setString(6, donor_gender);
							statement.setString(7, donor_street);
							statement.setString(8, donor_city);
							statement.setString(9, donor_state);
							statement.setString(10, donor_postal_code);
							statement.setString(11, donor_subscription_status);
							statement.setString(12, anonymity_preference);

							// Actually execute the populated query
							final int rows_inserted = statement.executeUpdate();
							System.out.println(
									String.format("Done. %d rows inserted into Person and Donor tables.",
											rows_inserted));
						}
						// account for multi-valued attribute of phone numbers
						try (final PreparedStatement statement = connection
								.prepareStatement("EXEC add_phone @person_ID = ?, @phone_number = ?;")) {
							System.out.println("How many phone numbers would you like to add for donor (0 for none)?");
							final int num_phones = sc.nextInt();
							sc.nextLine();// consume new line character from nextInt

							// loop based on how many phone numbers that the user wants to insert
							for (int i = 0; i < num_phones; i++) {
								System.out.println("Please enter phone number for donor: ");
								String phone_number = sc.nextLine(); // variable is not final since it needs to be
								// reassigned after every iteration

								// set stored procedure input parameters
								statement.setInt(1, donor_ID);
								statement.setString(2, phone_number);
								// Actually execute the populated query
								final int rows_inserted = statement.executeUpdate();
								System.out.println(
										String.format("Done. %d rows inserted into Person_phone table.",
												rows_inserted));
							}
						}
						// account for multi-valued attribute of email
						try (final PreparedStatement statement = connection
								.prepareStatement("EXEC add_email @person_ID = ?, @email_address = ?;")) {
							System.out
							.println("How many email addresses would you like to add for donor (0 for none)?");
							final int num_emails = sc.nextInt();
							sc.nextLine();// consume new line character from nextInt

							// loop based on how many phone numbers that the user wants to insert
							for (int i = 0; i < num_emails; i++) {
								System.out.println("Please enter email for donor: ");
								String email = sc.nextLine(); // variable is not final since it needs to be reassigned
								// after
								// every iteration

								// set input parameters for stored procedure
								statement.setInt(1, donor_ID);
								statement.setString(2, email);
								// Actually execute the populated query
								final int rows_inserted = statement.executeUpdate();
								System.out.println(
										String.format("Done. %d rows inserted into Person_email table.",
												rows_inserted));
							}
						}
						// lastly, account for emergency contacts that each ranger might have (used in
						// query 8)
						try (final PreparedStatement statement = connection.prepareStatement(
								"EXEC add_emergency_contact @person_ID = ?, @contact_name = ?, @relationship = ?, @phone_number = ?;")) {
							System.out.println(
									"How many emergency contacts would you like to add for this donor (0 for none)?");
							final int number_contacts = sc.nextInt(); // use in for loop
							sc.nextLine();// consume new line character from nextInt

							// loop based on how many emergency contacts that the user wants to insert
							for (int i = 0; i < number_contacts; i++) {
								// collect all attributes for Emergency_contact
								System.out.println("Please enter emergency contact name: ");
								String contact_name = sc.nextLine(); // variable is not final since it needs to be
								// reassigned after every iteration
								System.out.println("Please enter relationship to the donor: ");
								String relationship = sc.nextLine();
								System.out.println("Please enter phone number for emergency contact: ");
								String emergency_phone_number = sc.nextLine();

								// populate query template
								statement.setInt(1, donor_ID);
								statement.setString(2, contact_name);
								statement.setString(3, relationship);
								statement.setString(4, emergency_phone_number);

								// Actually execute the populated query
								final int rows_inserted = statement.executeUpdate();
								System.out.println(String.format("Done. %d rows inserted into Emergency_contact table.",
										rows_inserted));
							}
						}
					}
					//prompt user for what type of donation that they want to make (credit or check)
					System.out.println("What type of donation would you like to insert for the donor (check OR credit card)? "); 
					final String donation_type = sc.nextLine();
					// execute insertion query based on donation type
					if (donation_type.equalsIgnoreCase("check")) {
						// call stored procedure that inserts into Check_donation table
						try (final PreparedStatement statement = connection.prepareStatement(
								"EXEC insert_check_donation @person_ID = ?, @donation_date = ?, @amount = ?, @campaign_name = ?, @check_number = ?;")) {
							// get donation details
							System.out.println("Please enter donation date: ");
							final String check_donation_date = sc.nextLine();
							System.out.println("Please enter donation amount: ");
							BigDecimal check_donation_amount = new BigDecimal(sc.nextLine()); // use BigDecimal for donation amount because it gets converted to NUMERIC
							System.out.println("Please enter campaign name (optional): ");
							final String campaign_name = sc.nextLine();
							System.out.println("Please enter check number: ");
							final String check_number = sc.nextLine();

							// Setting the storage procedure input parameter values
							statement.setInt(1, donor_ID);
							statement.setString(2, check_donation_date);
							statement.setBigDecimal(3, check_donation_amount);
							statement.setString(4, campaign_name);
							statement.setString(5, check_number);

							// Actually execute the populated query
							final int rows_inserted = statement.executeUpdate();
							System.out.println(
									String.format("Done. %d rows inserted into Check_donation table.",
											rows_inserted));
						}
					} else {
						// use stored procedure that inserts into Credit_card_donation table
						try (final PreparedStatement statement = connection.prepareStatement(
								"EXEC insert_credit_card_donation @person_ID = ?, @donation_date = ?, @amount = ?, @campaign_name = ?, @card_type = ?, @last_four_digits = ?, @expiration_date = ?;")) {
							// get credit card donation details
							System.out.println("Please enter donation date: ");
							final String card_donation_date = sc.nextLine();
							System.out.println("Please enter donation amount: ");
							BigDecimal card_donation_amount = new BigDecimal(sc.nextLine()); // use BigDecimal for
							// donation amount
							// because it gets
							// converted to NUMERIC
							System.out.println("Please enter campaign name (optional): ");
							final String optional_campaign_name = sc.nextLine();
							System.out.println("Please enter card type: ");
							final String card_type = sc.nextLine();
							System.out.println("Please enter last four digits of credit card: ");
							final String last_four_digits = sc.nextLine();
							System.out.println("Please enter card expiration date: ");
							final String card_expiration_date = sc.nextLine();

							// Setting the storage procedure input parameter values
							statement.setInt(1, donor_ID);
							statement.setString(2, card_donation_date);
							statement.setBigDecimal(3, card_donation_amount);
							statement.setString(4, optional_campaign_name);
							statement.setString(5, card_type);
							statement.setString(6, last_four_digits);
							statement.setString(7, card_expiration_date);

							// Actually execute the populated query
							final int rows_inserted = statement.executeUpdate();
							System.out.println(
									String.format("Done. %d rows inserted into Credit_card_donation table.",
											rows_inserted));
						}
					}
				}
				break;
			case "5":
				// Collect input data from user
				System.out.println("Please enter researchers's ID: ");
				final int researcher_ID = sc.nextInt(); // Read in the user input for person_ID

				System.out.println("Please enter researchers's first name:");
				// Preceding nextInt, nextFloat, etc. does not consume new line characters from the user input.
				// We call nextLine to consume that newline character, so that s	ubsequent nextLine doesn't return nothing.
				sc.nextLine();
				final String researcher_first_name = sc.nextLine(); // Read in user input of Person's First Name (white-spaces allowed).

				System.out.println("Please enter researchers's last name:");
				// No need to call nextLine extra time here, because the preceding nextLine
				// consumed the newline character.
				final String researcher_last_name = sc.nextLine(); // Read in user input of person Last Name (white-spaces allowed).

				System.out.println("Please enter researchers's middle initial (1 character, if any): ");
				final String researcher_middle_initial = sc.nextLine();

				System.out.println("Please enter researchers's DOB (YYYY-MM-DD): ");
				final String researcher_DOB = sc.nextLine();

				System.out.println("Please enter researchers's gender (M or F): ");
				final String researcher_gender = sc.nextLine();

				System.out.println("Please enter researchers's street address: ");
				final String researcher_street = sc.nextLine();

				System.out.println("Please enter researchers's city: ");
				final String researcher_city = sc.nextLine();

				System.out.println("Please enter researchers's state abbreviation (e.g., AZ): ");
				final String researcher_state = sc.nextLine();

				System.out.println("Please enter researchers's postal code: ");
				final String researcher_postal_code = sc.nextLine();

				System.out.println("Is person subscribed to newsletter from NPSS? (Y or N):");
				final String researcher_subscription_status = sc.nextLine();

				System.out.println("Please enter researcher's research field (e.g., ecology):");
				final String research_field = sc.nextLine();

				System.out.println("Please enter researcher's hire date (YYYY-MM-DD): ");
				final String researcher_hire_date = sc.nextLine();

				System.out.println("Please enter researcher's salary: ");
				BigDecimal researcher_salary = new BigDecimal(sc.nextLine()); // use BigDecimal for salary because it gets converted to NUMERIC in SQL


				// execute queries in database
				System.out.println("Connecting to the database...");
				// Get a database connection and prepare a query statement
				try (final Connection connection = DriverManager.getConnection(URL)) {
					// insert into Person and Researcher tables using stored procedure
					try (final PreparedStatement statement = connection.prepareStatement("EXEC insert_researcher @person_ID = ?, @first_name = ?, @last_name = ?, @middle_initial = ?, @date_of_birth = ?, @gender = ?, @street = ?, @city = ?, @us_state = ?, @postal_code = ?, @subscribed_to_newsletter = ?, @research_field = ?, @hire_date = ?, @salary = ?;")) {
						// Populate the query template with the data collected from the user
						statement.setInt(1, researcher_ID);
						statement.setString(2, researcher_first_name);
						statement.setString(3, researcher_last_name);
						statement.setString(4, researcher_middle_initial);
						statement.setString(5, researcher_DOB);
						statement.setString(6, researcher_gender);
						statement.setString(7, researcher_street);
						statement.setString(8, researcher_city);
						statement.setString(9, researcher_state);
						statement.setString(10, researcher_postal_code);
						statement.setString(11, researcher_subscription_status);
						statement.setString(12, research_field);
						statement.setString(13, researcher_hire_date);
						statement.setBigDecimal(14, researcher_salary);

						// Actually execute the populated query
						final int rows_inserted = statement.executeUpdate();
						System.out.println(String.format("Done. %d rows inserted into Person and Researcher tables.", rows_inserted));
					}
					// associate researcher with one or more ranger teams using stored procedure (only insert team_ID and person_ID into Reports_to table)
					try (final PreparedStatement statement = connection.prepareStatement("EXEC query_5 @team_ID = ?, @person_ID = ?;")) {
						System.out.println("How many ranger teams would you like to associate with this researcher (0 for none)? ");
						final int number_teams = sc.nextInt();
						sc.nextLine(); // consume newline from preceding nextInt

						// use for loop to associate researcher with ranger teams (by inserting multiple tuples into the Reports_to table)
						for (int i = 0; i < number_teams; i++) {
							//prompt user for information in Reports_to table
							//variables are not final because they must be reassigned after every iteration
							//ranger teams must already exist in database
							System.out.println("Please enter ranger team's ID that you want to associate with researcher: ");
							int team_ID = sc.nextInt();
							sc.nextLine();//consume newline character from preceding nextInt()

							// set input parameters for stored procedure 
							statement.setInt(1, team_ID); //set team_ID from Ranger table
							statement.setInt(2, researcher_ID); //set person_ID from Researcher table

							// Actually execute the populated query
							statement.executeUpdate();
							System.out.println("Done. Associated researcher researcher with ranger team!");
						}
					}
					// account for multi-valued attributes of phone numbers using stored procedure
					try (final PreparedStatement statement = connection.prepareStatement("EXEC add_phone @person_ID = ?, @phone_number = ?;")) {
						System.out.println("How many phone numbers would you like to add for researcher (0 for none)?");
						final int number_phones = sc.nextInt();
						sc.nextLine();// consume new line character from nextInt

						// loop based on how many phone numbers that the user wants to insert
						for (int i = 0; i < number_phones; i++) {
							System.out.println("Please enter phone number for researcher: ");
							String phone_number = sc.nextLine(); // variable is not final since it needs to be reassigned after every iteration

							// populate query template
							statement.setInt(1, researcher_ID);
							statement.setString(2, phone_number);
							// Actually execute the populated query
							final int rows_inserted = statement.executeUpdate();
							System.out.println(
									String.format("Done. %d rows inserted into Person_phone table.",
											rows_inserted));
						}
					}
					// account for multi-valued attribute of emails
					try (final PreparedStatement statement = connection.prepareStatement("EXEC add_email @person_ID = ?, @email_address = ?;")) {
						System.out.println("How many email addresses would you like to add for researcher (0 for none)?");
						final int number_emails = sc.nextInt();
						sc.nextLine();// consume new line character from nextInt

						// loop based on how many phone numbers that the user wants to insert
						for (int i = 0; i < number_emails; i++) {
							System.out.println("Please enter email for visitor: ");
							String email = sc.nextLine(); // variable is not final since it needs to be reassigned after every iteration

							// populate query template
							statement.setInt(1, researcher_ID);
							statement.setString(2, email);
							// Actually execute the populated query
							final int rows_inserted = statement.executeUpdate();
							System.out.println(
									String.format("Done. %d rows inserted into Person_email table.",
											rows_inserted));
						}
					}
					// lastly, account for emergency contacts that each researcher might have (for query 8)
					try (final PreparedStatement statement = connection
							.prepareStatement("EXEC add_emergency_contact @person_ID = ?, @contact_name = ?, @relationship = ?, @phone_number = ?;")) {
						System.out.println(
								"How many emergency contacts would you like to add for this researcher (0 for none)?");
						final int number_contacts = sc.nextInt(); // use in for loop
						sc.nextLine();// consume new line character from nextInt

						// loop based on how many emergency contacts that the user wants to insert
						for (int i = 0; i < number_contacts; i++) {
							// collect all attributes for Emergency_contact
							System.out.println("Please enter contact name for visitor: ");
							String contact_name = sc.nextLine(); // variable is not final since it needs to be reassigned after every iteration
							System.out.println("Please enter relationship to the visitor: ");
							String relationship = sc.nextLine();
							System.out.println("Please enter phone number for emergency contact: ");
							String emergency_phone_number = sc.nextLine();

							// populate query template
							statement.setInt(1, researcher_ID);
							statement.setString(2, contact_name);
							statement.setString(3, relationship);
							statement.setString(4, emergency_phone_number);

							// Actually execute the populated query
							final int rows_inserted = statement.executeUpdate();
							System.out.println(String.format("Done. %d rows inserted into Emergency_contact table.", rows_inserted));
						}
					}
				}
				break;
			case "6":
				// Prompt user for team_ID of ranger team and person_ID of researcher to access tuple indicating their relationship
				System.out.println("Please enter ranger team ID: ");
				final int team_ID = sc.nextInt();
				sc.nextLine();//consume new line character from nextInt()
				System.out.println("Please enter researcher ID that ranger team reports to: ");
				final int researcher_id = sc.nextInt();
				sc.nextLine();//consume new line character from nextInt()
				System.out.println("Please enter report date (YYYY-MM-DD):");
				final String report_date = sc.nextLine();
				System.out.println("Please enter summary of activities for the report: ");
				final String activities_summary = sc.nextLine();

				// execute queries in database
				System.out.println("Connecting to the database...");
				// Get a database connection and prepare a query statement
				try (final Connection connection = DriverManager.getConnection(URL)) {
					//use stored procedure to insert the report submitted from a ranger team to a researcher
					try (final PreparedStatement statement = connection.prepareStatement("EXEC add_report @team_ID = ?, @person_ID = ?, @report_date = ?, @activities_summary = ?;")) {
						// Populate the query template with the data collected from the user
						statement.setInt(1, team_ID);
						statement.setInt(2, researcher_id);
						statement.setString(3, report_date);
						statement.setString(4, activities_summary);

						// Actually execute the populated query
						statement.executeUpdate();
						System.out.println("Done. Added report submitted from ranger team to researcher");
					}
				}
				break;
			case "7":
				sc.nextLine();// consume new line character from next()
				// ask user if National Park exists yet
				System.out.println("Does the national park exist yet (Y or N)? ");
				final String exists = sc.nextLine();
				// connect to database
				try (final Connection connection = DriverManager.getConnection(URL)) {
					// if park doesn't exist yet, create new National Park before adding new park
					// program(s)
					System.out.println("Please enter National Park name: ");
					final String park_name = sc.nextLine();
					if (exists.equalsIgnoreCase("N")) {
						System.out.println("Please enter National Park's street: ");
						final String new_park_street = sc.nextLine();
						System.out.println("Please enter National Park's city: ");
						final String new_park_city = sc.nextLine();
						System.out.println("Please enter National Park's state abbreviation: ");
						final String new_park_state = sc.nextLine();
						System.out.println("Please enter National Park's postal code: ");
						final String new_park_postal = sc.nextLine();
						System.out.println("Please enter National Park's establishment date (YYYY-MM-DD): ");
						final String new_park_establishment = sc.nextLine();
						System.out.println("Please enter National Park's visitor capacity: ");
						final int new_park_capacity = sc.nextInt();
						sc.nextLine(); // consume new line character

						// execute stored procedure that adds new National Park to database first
						try (final PreparedStatement statement = connection.prepareStatement(
								"EXEC add_national_park @park_name = ?, @street = ?, @city = ?, @us_state = ?, @postal_code = ?, @establishment_date = ?, @visitor_capacity = ?;")) {

							// set stored procedure input parameters
							statement.setString(1, park_name);
							statement.setString(2, new_park_street);
							statement.setString(3, new_park_city);
							statement.setString(4, new_park_state);
							statement.setString(5, new_park_postal);
							statement.setString(6, new_park_establishment);
							statement.setInt(7, new_park_capacity);

							// Actually execute the populated query
							final int rows_inserted = statement.executeUpdate();
							System.out.println(
									String.format("Done. %d rows inserted into National_park table.",
											rows_inserted));
						}
					}
					// otherwise, if national park already exists, new park program given the
					// National Park name (park should already exist, since Program depends on
					// National Park)
					// prompt user for program data
					System.out.println("Please enter program name: ");
					final String program_name = sc.nextLine();
					System.out.println("Please enter program type (e.g, recreational, educational):");
					final String program_type = sc.nextLine();
					System.out.println("Please enter program start date (YYYY-MM-DD): ");
					final String program_start_date = sc.nextLine();
					System.out.println("Please enter program duration (in hours): ");
					final int program_duration = sc.nextInt();
					sc.nextLine(); // consume new line character from nextInt
					// execute stored procedure that inserts into Program table
					try (final PreparedStatement statement = connection.prepareStatement(
							"EXEC add_program @park_name = ?, @program_name = ?, @program_type = ?, @program_start_date = ?, @duration = ?;")) {
						// set stored procedure input parameters
						statement.setString(1, park_name);
						statement.setString(2, program_name);
						statement.setString(3, program_type);
						statement.setString(4, program_start_date);
						statement.setInt(5, program_duration);

						// Actually execute the populated query
						final int rows_inserted = statement.executeUpdate();
						System.out.println(
								String.format("Done. %d rows inserted into Program table.", rows_inserted));
					}
				}
				break;
			case "8":
				// get emergency contacts for a specific person using stored procedure
				System.out.println(
						"Please enter person_ID of person who you want to retrieve emergency contacts for: ");// prompt
				// user
				// for
				// person
				// id
				final int id = sc.nextInt();
				sc.nextLine();// consume new line character from nextInt
				System.out.println("Connecting to the database...");
				try (final Connection connection = DriverManager.getConnection(URL)) {
					System.out.println("Dispatching the query...");
					try (final PreparedStatement statement = connection
							.prepareStatement("EXEC retrieve_emergency_contacts @person_ID = ?;")) {

						// Setting the storage procedure input parameter values
						statement.setInt(1, id);

						// Call the stored procedure
						ResultSet resultSet = statement.executeQuery();

						System.out.println("Emergency Contacts:");
						System.out.println("contact_name | relationship | phone_number ");

						while (resultSet.next()) {
							System.out.println(String.format("%s | %s | %s ",
									resultSet.getString(1),
									resultSet.getString(2),
									resultSet.getString(3)));
						}
					}
				}

				break;
			case "9":
				//Retrieve the list of visitors enrolled in a specific park program, including their accessibility needs
				// prompt user for park_name and program_name since they are primary key of weak entity set Program
				sc.nextLine(); //consume newline character from next()
				System.out.println("Please enter National Park name: ");
				final String park_name = sc.nextLine();
				System.out.println("Please enter name of program belonging to that park: ");
				final String program_name = sc.nextLine();

				System.out.println("Connecting to the database...");
				try (final Connection connection = DriverManager.getConnection(URL)) {
					System.out.println("Dispatching the query...");
					try (final PreparedStatement statement = connection.prepareStatement("EXEC retrieve_visitor_enrollment @park_name = ?, @program_name = ?;")) {

						// Setting the storage procedure input parameter values
						statement.setString(1, park_name);
						statement.setString(2, program_name);
						// Call the stored procedure
						ResultSet resultSet = statement.executeQuery();

						System.out.println("List of visitors enrolled in " + program_name + " from " + park_name + ":");
						System.out.println("Visitor ID | First Name | Last Name | Visit Date | Accessibility Needs ");

						while (resultSet.next()) {
							System.out.println(String.format("%s | %s | %s | %s | %s ",
									resultSet.getString(1),
									resultSet.getString(2),
									resultSet.getString(3),
									resultSet.getString(4),
									resultSet.getString(5)
									));
						}
					}
				}
				break;
			case "10":
				//Retrieve all park programs for a specific park that started after a given date
				//prompt user for National Park name so that we can look for all programs associated with it in Program table
				sc.nextLine(); //consume newline character from next()
				System.out.println("Please enter National Park name: ");
				final String national_park = sc.nextLine();
				System.out.println("Please enter date (YYYY-MM-DD): ");//prompt for date 
				final String date = sc.nextLine();

				//execute stored procedure with given National Park and given date
				System.out.println("Connecting to the database...");
				try (final Connection connection = DriverManager.getConnection(URL)) {
					System.out.println("Dispatching the query...");
					try (final PreparedStatement statement = connection.prepareStatement("EXEC query_10 @park_name = ?, @given_date = ?;")) {

						// Setting the storage procedure input parameter values
						statement.setString(1, national_park);
						statement.setString(2, date);
						// Call the stored procedure
						ResultSet resultSet = statement.executeQuery();

						System.out.println("Park Programs for " + national_park + " that started after " + date);
						System.out.println("National Park | Program Name | Program Type | Program Start Date | Duration (hours) ");

						while (resultSet.next()) {
							System.out.println(String.format("%s | %s | %s | %s | %s ",
									resultSet.getString(1),
									resultSet.getString(2),
									resultSet.getString(3),
									resultSet.getString(4),
									resultSet.getString(5)
									));
						}
					}
				}
				break;
			case "11":
				// donors are NOT assumed to all be anonymous

				break;
			case "12":
				break;
			case "13":
				// Retrieve the names, IDs, contact information, and newsletter subscription
				// status of all individuals in the database
				System.out.println("Connecting to the database...");
				// Get the database connection, create statement and execute it right away, as
				// no user input need be collected
				try (final Connection connection = DriverManager.getConnection(URL)) {
					System.out.println("Dispatching the query...");
					// get attributes from person table
					try (final Statement statement = connection.createStatement(); final ResultSet resultSet = statement.executeQuery(RETRIEVE_PEOPLE)) {

						System.out.println("Contents of the Person table:");
						System.out.println(
								"person_ID | first_name | last_name | middle_initial | subscribed_to_newsletter ");

						// Unpack the tuples returned by the database and print them out to the user
						while (resultSet.next()) {
							System.out.println(String.format("%s | %s | %s | %s | %s ", resultSet.getString(1),
									resultSet.getString(2), resultSet.getString(3), resultSet.getString(4),
									resultSet.getString(5)));
						}
						System.out.println();
					}
					// get entire Person_phone table
					try (final Statement statement = connection.createStatement(); final ResultSet resultSet = statement.executeQuery(RETRIEVE_PHONE_NUMBERS)) {

						System.out.println("Contents of the Person_phone table:");
						System.out.println("person_ID | phone_number ");

						// Unpack the tuples returned by the database and print them out to the user
						while (resultSet.next()) {
							System.out
							.println(String.format("%s | %s ", resultSet.getString(1),
									resultSet.getString(2)));
						}
						System.out.println();
					}
					try (final Statement statement = connection.createStatement(); final ResultSet resultSet = statement.executeQuery(RETRIEVE_EMAILS)) {

						System.out.println("Contents of the Person_email table:");
						System.out.println("person_ID | email_address ");

						// Unpack the tuples returned by the database and print them out to the user
						while (resultSet.next()) {
							System.out
							.println(String.format("%s | %s ", resultSet.getString(1),
									resultSet.getString(2)));
						}
					}
				}
				break;
			case "14":
				break;
			case "15":
				break;

			case "18": // Do nothing, the while loop will terminate upon the next iteration
				System.out.println("Exiting! Good-bye!");
				break;
			default: // Unrecognized option, re-prompt the user for the correct one
				System.out.println(String.format("Unrecognized option: %s\n" + "Please try again!", option));
				break;
			}
		}

		sc.close(); // Close the scanner before exiting the application
	}
}
